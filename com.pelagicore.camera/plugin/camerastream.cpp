/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtAuto Extra Apps.
**
** $QT_BEGIN_LICENSE:BSD-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/
#include "camerastream.h"
#include "QQuickWindow"
#include <QSGSimpleTextureNode>
#include <QSGTexture>
#include <QOpenGLTexture>
#include <QOpenGLContext>
#include <QOpenGLExtraFunctions>
#include <QtGui>

#ifdef Q_OS_UNIX
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#endif

#define WIDTH 1280
#define HEIGHT 1080

//--------------------------------------------
#define SWAP_COLORS
//--------------------------------------------

CameraStream::CameraStream(QQuickItem* parent)
    : QQuickItem(parent)
    , m_enableBenchmarkFirstFrameRendered(true)
{
    m_renderTimer.setInterval(30);
    m_renderTimer.setSingleShot(false);

    m_framecount = 0;

    m_fb = new uint8_t[WIDTH*HEIGHT*4];
    m_tfb = new uint8_t[WIDTH*HEIGHT*4];

    connect(this, &QQuickItem::visibleChanged, this, &CameraStream::cameraVisibleChanged);
    connect(&m_renderTimer, &QTimer::timeout, this, &QQuickItem::update);

    this->setFlag(QQuickItem::ItemHasContents, true);

    m_image = new QImage(m_fb, WIDTH, HEIGHT, QImage::Format_RGB888);

    m_renderTimer.start();

    m_angle = 0;
}

CameraStream::~CameraStream()
{
    delete m_fb;
    delete m_tfb;
    delete m_image;
}

void CameraStream::cameraVisibleChanged()
{
    if (isVisible()) {
        m_renderTimer.start();
    } else {
        m_renderTimer.stop();
    }
}

int CameraStream::angle() const
{
    return m_angle;
}

void CameraStream::setAngle(int angle)
{
    if (angle < 0)
        angle = 0;
    if (angle >= NUM_CAMERAS)
        angle = NUM_CAMERAS-1;

    if (m_angle != angle) {
        m_angle = angle;
#ifdef Q_OS_UNIX
        int f;
        f = open("/dev/framegrabber", O_RDONLY);
        if (f >= 0) {
            ioctl(f, 0, m_angle);
            close(f);
        }
#endif
        emit angleChanged(angle);
    }
}

int CameraStream::hdmiAngle() const
{
    return m_hdmi_angle;
}

void CameraStream::setHdmiAngle(int angle)
{
    if (angle < 0)
        angle = 0;
    if (angle >= NUM_CAMERAS)
        angle = NUM_CAMERAS-1;

    if (m_hdmi_angle != angle) {
        m_hdmi_angle = angle;
#ifdef Q_OS_UNIX
        int f;
        f = open("/dev/framegrabber", O_RDONLY);
        if (f >= 0) {
            ioctl(f, 1, m_hdmi_angle);
            close(f);
        }
#endif
        emit hdmiAngleChanged(angle);
    }
}

QString CameraStream::lastError() const
{
    return m_lastError;
}

void CameraStream::firstFrameRenderBenchmark()
{
    emit firstFrameRendered();
    disconnect(this->window(), &QQuickWindow::frameSwapped, this, &CameraStream::firstFrameRenderBenchmark);
}

QSGNode* CameraStream::updatePaintNode(QSGNode* oldNode, UpdatePaintNodeData*)
{
    QQuickWindow *win = QQuickItem::window();

    QSGSimpleTextureNode *textureNode = static_cast<QSGSimpleTextureNode *>(oldNode);
    if (!textureNode)
        textureNode = new QSGSimpleTextureNode();

    if (textureNode->texture()) {
        delete textureNode->texture();
    }

    copyFrame();

    QImage resizedImage = m_image->scaled(width(), height(), Qt::KeepAspectRatio);
    auto texture = win->createTextureFromImage(resizedImage);
    textureNode->setTexture(texture);

    textureNode->markDirty(QSGNode::DirtyMaterial);

    textureNode->setRect(0, 0, width(), height());

    m_framecount++;
    //enable capturing first frame swap signal after refreshing the first paint of this node.
    if (m_enableBenchmarkFirstFrameRendered && isVisible()) {
        connect(this->window(), &QQuickWindow::frameSwapped, this, &CameraStream::firstFrameRenderBenchmark);
        m_enableBenchmarkFirstFrameRendered = false;
    }

    return textureNode;
}

void CameraStream::copyFrame() {
#ifdef ABGR
    int x, y;
    uint32_t tmp;
#endif
    uint32_t *s, *t;

    s = reinterpret_cast<uint32_t *>(m_tfb);
    t = reinterpret_cast<uint32_t *>(m_fb);

#ifdef Q_OS_UNIX
    int f;
    f = open("/dev/framegrabber", O_RDONLY);
    if (f >= 0) {
        m_lastError.clear();
        ssize_t num;
        num = read(f, m_tfb, WIDTH*HEIGHT*3);
        if (num < WIDTH*HEIGHT*3)
            qCritical() << "read() returned " << num;
        close(f);
    } else {
        m_lastError = QLatin1String(strerror(errno));
        emit lastErrorChanged(m_lastError);
    }
#else
    m_lastError = QLatin1String("no camera support on windows");
    emit lastErrorChanged(m_lastError);
#endif

#ifdef ABGR
    for (y = 0; y < HEIGHT;y++) {
        for (x = 0; x < WIDTH;x++) {
            tmp = s[y * WIDTH + x];
#ifdef SWAP_COLORS
            tmp =
                ((tmp & 0x00ff0000) >> 16) |
                ((tmp & 0x000000ff) << 16) |
                (tmp & 0x0000ff00);
#endif
            tmp |= 0xff000000;
            *t++ = tmp;
        }
    }
#else
    memcpy(t, s, WIDTH*HEIGHT*3);
#endif
}
