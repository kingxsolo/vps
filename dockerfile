FROM --platform=linux/amd64 ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. تحديث النظام وتثبيت الحزم الأساسية + Python النظامية مع pip
RUN apt-get update -y && apt-get install -y \
    openssh-server \
    sudo \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    ffmpeg \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 2. تفعيل الأمر pip مباشرة (رابط رمزي من pip إلى pip3)
RUN ln -sf /usr/bin/pip3 /usr/bin/pip

# 3. ترقية pip وإدارة الحزم (مع تجاوز قيد PEP 668)
RUN pip install --upgrade pip setuptools wheel --break-system-packages

# 4. تثبيت Node.js 24 LTS (يشمل npm) عبر NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 5. تثبيت مكتبات Python المطلوبة باستخدام pip مباشرة
RUN pip install --no-cache-dir --break-system-packages \
    mtranslate \
    google-genai \
    requests \
    g4f \
    mutagen \
    tgcalls==3.0.0.dev6 \
    py-tgcalls~=2.2.11 \
    telethon \
    aiosqlite \
    aiocron \
    emoji \
    pytz \
    gtts \
    qrcode \
    Telegram \
    aiohttp \
    fake_useragent \
    user_agent \
    hijri_converter \
    gpytranslate \
    watchdog

WORKDIR /root

# 6. إعداد SSH
RUN mkdir /var/run/sshd
RUN echo "root:solo-8787" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
