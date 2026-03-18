#!/bin/bash
# Скрипт для установки панели 3x-ui и конфигурирования базовой безопасности сервера

### ПЕРЕМЕННЫЕ НЕ МЕНЯТЬ ###
# Генерируем случайное имя пользователя
USERNAME=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1)
# Генерируем случайный пароль
PASSWORD=$(cat /dev/urandom | tr -dc 'A-Za-z0-9@#$%&*' | fold -w 12 | head -n 1)
PASSWORD_ROOT=$(cat /dev/urandom | tr -dc 'A-Za-z0-9@#$%&*' | fold -w 12 | head -n 1)
# Генерируем случайный порт для ssh между 1024 and 65535
PORT=$((RANDOM % (65535 - 1024 + 1) + 1024))
# Получаем имя сетевого интерфейса
IFACE_NAME=$(ip link | awk -F': ' '/^[0-9]+: / {print $2}' | sed -n '2p')
# Получаем ip сетевого интерфейса
IFACE_IP=$(ip -o -4 addr show | awk 'NR==2 {print $4}' | cut -d'/' -f1)
# цвета
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
### ПЕРЕМЕННЫЕ НЕ МЕНЯТЬ ###

clear
cat <<'EOF'
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⣀⣀⣀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠉⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀YOU⠀⠀⠀⠀⠀ ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠉⠁⠀⠉⠉⠛⢿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⡀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿
⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣷⣄⠀⠀⠀⠀⠹⣿⣿⣿⡿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿
⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠿⠛⠉⠉⠳⣄⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⢀⠀⠁⠀⠀⠀⠀⢠⣿
⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⣾⠏⠀⠀⠀⠀⠀⠙⠦⡀⠀⠀⠀⣻⣿⣿⣿⣿⣿⠀⠀⠀⠀⠠⠀⠀⠀⠀⢀⣠⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠙⠆⠠⠔⠃⠀⠀⠉⠀⠀⠀⠀⠀⠀⠰⢶⣶⣶⣾⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⣿⡇⠀ ⠀⠀⠀ROSKOMPOZOR      ⢸⣿⣾⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⢹⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢸⣿⣾⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⡄⠀⠀⠀⠀⠀⢸⣿⣿⣷⣶⣶⡄⠀⠀⠀⠀⠠⠀⠀⠀⢀⣶⣿⣿⣿⣿⣿⣿⣿
⣿⠟⠋⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⢸⣿⣇⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣆⡀⠀⠀⡀⠄⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿
⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠉⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠂⠀⠀⠘⠻⠯⠿⠿⠿⠿⠿⢿
⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠈⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣿⣶⣶⣦⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣾⣤⣤⣤⣤⣤⣤⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣾
EOF



# Проверка что установка производится из под root
if [[ $EUID -ne 0 ]]; then
echo -e "\n${RED}Установка должна производиться под суперпользователем root."
echo -e "Для перехода в режим суперпользователя используйте команду: sudo -i${NC}"
exit 1
fi

echo -e "\n${YELLOW}Внимание !!!"
echo -e "Убедитесь что вы получили доменное имя для ip адреса этого сервера."
echo -e "Скрипт предназначен для Ubuntu 22.04 или выше."
echo -e "Установка должна производиться на чистую машину!"
echo -e "Вводить домен в формате FQDM (example.duckdns.org).${NC}"
read -p "$(echo -e $CYAN)Введите доменное имя вашего сервера: $(echo -e $NC)" DOMAIN

# Проверяем что домен не пустой
if [[ -z "$DOMAIN" ]]; then
    echo -e "${RED}Доменное имя не может быть пустым. Завершаю выполнение скрипта.${NC}"
    exit 1
fi

DOMAIN_IP=$(nslookup "$DOMAIN" | awk '/^Address: / {print $2}' | tail -n1)

if [[ -z "$DOMAIN_IP" ]]; then
    echo -e "${RED}Не удалось получить DNS запись домена:${NC} ${DOMAIN}."
    echo -e "${RED}Убедитесь что домен введен верно и запустите скрипт повторно.${NC}"
    exit 1
fi

# Сравниваем ip адрес интерфейса сервера и ip присвоенный домену в DNS
if [[ "$DOMAIN_IP" == "$IFACE_IP" ]]; then
    echo -e "${GREEN}Адрес сервера совпадает с DNS записью.${NC}"
else
    echo -e "${RED}Адрес сервера не совпадает с DNS записью:${NC} ${DOMAIN}."
    echo -e "${RED}Убедитесь что вы получили домен для ip адреса сервера и запустите скрипт повторно.${NC}"
    exit 1
fi

# Запрашиваем у пользователя подтверждение
echo -e "\n${CYAN}Будет установлена панель 3x-ui."
echo -e "Будет создан sudo пользователь."
echo -e "Пользователь root больше не сможет заходить на сервер по ssh."
echo -e "Будет установлена и настроена служба knockd."
echo -e "Будет выпущен сертификат от Letsencrypt и настроено его автоматическое обновление."
echo -e "Будет настроено автоматическое обновление панели 3x-ui раз в месяц."
echo -e "Будет настроено автоматическое обновление операционной системы раз в квартал.${NC}"
read -p "$(echo -e $YELLOW)Вы согласны продолжить? (y/N): $(echo -e $NC)" CONFIRMATION

if [[ "$CONFIRMATION" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Подтверждено. Начинаем настройку сервера:${NC} $DOMAIN"
else
    echo -e "${RED}Не было получено подтверждение от пользователя. Завершаю выполнение скрипта.${NC}"
    exit 1
fi

# Меняем домен у сервера
hostnamectl set-hostname "$DOMAIN"

# Устанавливаем панель
echo -e "${CYAN}Начинаем установку панели 3x-ui.${NC}"
x-ui --help 2>/dev/null
if [[ $? -eq 0 ]]; then
    (echo 5; echo y) | x-ui
fi
echo no | /bin/bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) >>install_log.log 2>&1

# Устанавливаем дополнительные пакеты
echo -e "${CYAN}Устанавливаем дополнительные пакеты.${NC}"
apt update
DEBIAN_FRONTEND=noninteractive apt upgrade -y
dpkg --configure -a
DEBIAN_FRONTEND=noninteractive apt upgrade -y
DEBIAN_FRONTEND=noninteractive apt install openssl ca-certificates certbot knockd iptables iptables-persistent unattended-upgrades -y
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure unattended-upgrades

# Создаем пользователя из сгенерированных логина и пароля, а также делаем его суперпользователем
echo -e "${CYAN}Создаем sudo пользователя.${NC}"
adduser --disabled-password --gecos "xui admin" "$USERNAME"
usermod -aG sudo "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Меняем пароль root
echo "root:$PASSWORD_ROOT" | chpasswd

# Меняем порт в конфиге ssh и отключаем возможность логина под root
echo -e "${CYAN}Меняем ssh порт:${NC} $PORT"
grep '#Port' /etc/ssh/sshd_config && sed -i "/#Port/c\Port ${PORT}" /etc/ssh/sshd_config || sed -i "/Port/c\Port ${PORT}" /etc/ssh/sshd_config
sed -i "/^PermitRootLogin/c\PermitRootLogin no" /etc/ssh/sshd_config
systemctl restart ssh

# Настраиваем knockd
echo -e "${CYAN}Настраиваем службу knockd.${NC}"
cat <<EOF > /etc/knockd.conf 
[options]
	UseSyslog
	Interface = ${IFACE_NAME}

[SSH]
	sequence    = 11001,12002,13003
	seq_timeout = 5
	tcpflags    = syn
	start_command     = /sbin/iptables -I INPUT -s %IP% -p tcp --dport ${PORT} -j ACCEPT
	stop_command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport ${PORT} -j ACCEPT
	cmd_timeout   = 60
EOF

sed -i "/START_KNOCKD/c\START_KNOCKD=1" /etc/default/knockd
sed -i "/KNOCKD_OPTS/c\KNOCKD_OPTS=\"-i ${IFACE_NAME}\"" /etc/default/knockd
sudo systemctl enable --now knockd

# Настройка iptables и перманентное сохранение этих настроек
# запрещаем трафик по порту ssh и отключаем пинги
iptables -F
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport "$PORT" -j REJECT
sudo iptables -A INPUT -p icmp --icmp-type 8 -j DROP
sudo service netfilter-persistent save

# Получаем сертификаты
echo -e "${CYAN}Получаем ssl сертификаты.${NC}"
echo 1 | certbot certonly --standalone --agree-tos --register-unsafely-without-email -d "$DOMAIN"
mkdir -p /root/cert/${DOMAIN}
cp /etc/letsencrypt/live/${DOMAIN}/fullchain.pem /root/cert/${DOMAIN}
cp /etc/letsencrypt/live/${DOMAIN}/privkey.pem /root/cert/${DOMAIN}
(echo 18; echo 5; echo ${DOMAIN}; echo \r; echo 0) | x-ui

# Включаем BBR
(echo 23; echo 1; echo 0; echo 0) | x-ui

# Создаем сервис, запускающий команду для обновления панели 3x-ui
cat <<EOF > /etc/systemd/system/update-xui.service
[Unit]
Description=Monthly 3x-ui panel update service

[Service]
Type=oneshot
ExecStart=(echo 2; echo y) | x-ui
EOF

# Создаем таймер, по которому будет запущен сервис для обновления панели 3x-ui
cat <<EOF > /etc/systemd/system/update-xui.timer
[Unit]
Description=Monthly 3x-ui panel update timer

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Создаем сервис, запускающий скрипт для проверки и обновления сертификатов
cat <<EOF > /etc/systemd/system/check-certificate.service
[Unit]
Description=Daily certificate expire date check service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/check_cert_expire_date.sh
EOF

# Создаем таймер, по которому будет запущен сервис для проверки и обновления сертификатов
cat <<EOF > /etc/systemd/system/check-certificate.timer
[Unit]
Description=Daily certificate expire date check timer

[Timer]
OnCalendar=daily
AccuracySec=12h
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Создаем скрипт для проверки и обновления сертификатов, который будет запущен из сервиса
cat <<EOF > /usr/local/bin/check_cert_expire_date.sh
#!/bin/bash

CURRENT_CERT="/root/cert/${DOMAIN}/fullchain.pem"
CURRENT_KEY="/root/cert/${DOMAIN}/privkey.pem"

LE_CERT="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"
LE_KEY="/etc/letsencrypt/live/${DOMAIN}/privkey.pem"

TARGET_DIR="/root/cert/${DOMAIN}"

check_cert_expiry() {
    CERT_PATH=\$1
    if [ ! -f "\${CERT_PATH}" ]; then
        echo "Сертификат \${CERT_PATH} не найден. Интерпретируем как истекший."
        return 1
    fi

    EXPIRATION_DATE=\$(openssl x509 -enddate -noout -in "\${CERT_PATH}" | cut -d= -f2)
    EXPIRATION_TIMESTAMP=\$(date -d "\${EXPIRATION_DATE}" +%s)
    CURRENT_TIMESTAMP=\$(date +%s)

    if [ "\${CURRENT_TIMESTAMP}" -ge "\${EXPIRATION_TIMESTAMP}" ]; then
        echo "Сертификат \${CERT_PATH} истек."
        return 1
    fi
    echo "Сертификат \${CERT_PATH} действителен."
    return 0
}

check_cert_expiry "\$CURRENT_CERT"
CERT_EXPIRED=\$?
check_cert_expiry "\$CURRENT_KEY"
KEY_EXPIRED=\$?

if [ \${CERT_EXPIRED} -ne 0 ] || [ \${KEY_EXPIRED} -ne 0 ]; then
    echo "Копирую новый сертификат и ключ из Let's Encrypt директории."
    cp "\${LE_CERT}" "\${TARGET_DIR}/fullchain.pem"
    cp "\${LE_KEY}" "\${TARGET_DIR}/privkey.pem"
    echo "Новый сертификат и ключ успешно скопирован \${TARGET_DIR}."
	x-ui restart
else
    echo "Сертификаты не истекли, действий не требуется."
fi
EOF

# Создаем сервис, обновляющий ОС
cat <<EOF > /etc/systemd/system/quarterly-update.service
[Unit]
Description=Quarterly system update
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c '\
apt update && \
DEBIAN_FRONTEND=noninteractive apt -y full-upgrade && \
apt -y autoremove && \
if [ -f /var/run/reboot-required ]; then systemctl reboot; fi'
EOF

# Создаем таймер, по которому будет запущен сервис для обновления ОС
cat <<EOF > /etc/systemd/system/quarterly-update.timer
[Unit]
Description=Quarterly system update at night

[Timer]
OnCalendar=*-01,04,07,10-05 02:00
RandomizedDelaySec=2h
Persistent=true

[Install]
WantedBy=timers.target
EOF

chmod +x /usr/local/bin/check_cert_expire_date.sh

systemctl daemon-reload
systemctl enable --now check-certificate.timer
systemctl enable --now update-xui.timer
systemctl enable --now quarterly-update.timer
systemctl restart ssh


echo -e "\n${YELLOW}--- Скопируйте всю информацию ниже в безопасное место, без доступа посторонних лиц! ---${NC}"
grep 'Username:' install_log.log >> xui_info
grep 'Password:' install_log.log >> xui_info
grep 'Access URL:' install_log.log | sed -E "s|http://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|https://${DOMAIN}|" >> xui_info
echo "Новые данные для подключения к серверу:" >> xui_info
echo "Новый пользователь: $USERNAME" >> xui_info
echo "Пароль пользователя ${USERNAME}: $PASSWORD" >> xui_info
echo "Порт ssh: $PORT" >> xui_info
echo -e "knock ${IFACE_IP} 11001 12002 13003 -d 500 && ssh -p ${PORT} ${USERNAME}@${IFACE_IP}" >> xui_info
cat <<EOF >> xui_info
\$server = "${IFACE_IP}"
\$user = "${USERNAME}"
\$ports = @(11001, 12002, 13003)
# Стучимся в каждый порт из списка
foreach (\$port in \$ports) {
    try {
        # Создаем TCP клиент и пытаемся подключиться к серверу
        \$tcpClient = New-Object System.Net.Sockets.TcpClient
        \$tcpClient.Connect(\$server, \$port)
       
        # Закрываем соединение (на всякий случай)
        \$tcpClient.Close()
    } catch {
        Write-Output "Постучались на TCP порт \$port"
    }
}

# Попытка подключиться по ssh к серверу
Write-Output "Пытаемся подключиться по ssh к серверу \$server..."
Start-Process "ssh" -ArgumentList "\$user@\$server"
EOF

# Выводим информацию для пользователя
echo -e "${CYAN}--- Данные для входа в панель 3x-ui ---${GREEN}"
grep Username xui_info
grep Password xui_info
grep 'Access URL' xui_info
echo -e "${CYAN}------------${NC}"
echo -e "\n${GREEN}Новый пароль для пользователя root сервера: ${PASSWORD_ROOT}${NC}"
echo -e "\n${CYAN}--- Информация для Linux/MacOS ---" 
echo -e "Должна быть установлена утилита knock." 
echo -e "Для Linux можно установить командой в зависимости от дистрибутива:" 
echo -e "${YELLOW}apt install knock${NC} || ${YELLOW}dnf install knock${NC}" 
echo -e "\n${CYAN}Для MaccOS можно установить командой:${NC}" 
echo -e "${YELLOW}brew install knock${NC}"
echo -e "${CYAN}Если команда brew отсутствует, требуется установить Homebrew следующей командой:${YELLOW}"
echo 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
echo -e "\n${CYAN}Команда для подключения к серверу (Linux/MacOS):${YELLOW}"
grep '11001 12002 13003' xui_info
echo -en "${GREEN}"
grep 'Пароль пользователя' xui_info
echo -e "${CYAN}------------${NC}"
echo -e "\n${CYAN}--- Информация для Windows ---"
echo -e "Чтобы разрешить выполнения скриптов в системе, откройте powershell и введите туда команду:"
echo -e "${YELLOW}Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass"
echo -e "\n${CYAN}Скопируйте текст ниже (выделенное оранжевым) и сохраните его в текстовый файл (подойдет программа Блокнот) с именем TCPknock.ps1${YELLOW}"
cat <<EOF
\$server = "${IFACE_IP}"
\$user = "${USERNAME}"
\$ports = @(11001, 12002, 13003)
\$ssh_port = "${PORT}"
# Стучимся в каждый порт из списка
foreach (\$port in \$ports) {
    try {
        # Создаем TCP клиент и пытаемся подключиться к серверу
        \$tcpClient = New-Object System.Net.Sockets.TcpClient
        \$tcpClient.Connect(\$server, \$port)
       
        # Закрываем соединение (на всякий случай)
        \$tcpClient.Close()
    } catch {
        Write-Output "Постучались на TCP порт \$port"
    }
}

# Попытка подключиться по ssh к серверу
Write-Output "Пытаемся подключиться по ssh к серверу \$server..."
Start-Process "ssh" -ArgumentList -p \$ssh_port "\$user@\$server"
EOF

echo -e "\n${CYAN}Запустите сохраненный файл командой из powershell:"
echo -e "${YELLOW}./TCPknock.ps1${NC}"
echo -e "${CYAN}------------${NC}"

rm -f xui_info
rm -f install_log.log

echo -e "\n${GREEN}Установка панели и конфигурирование сервера выполнено!${NC}\n"
echo -e "\n${YELLOW}Обязательно ознакомьтесь со всей информацией выше вплоть до пункта с данными входа в панель 3x-ui и сохраните ее в безопасном месте!${NC}\n"

echo -e "${CYAN}Список рабочих доменов с хорошим пингом для маскировки на 30.12.2024.${NC}"
echo -e "${GREEN}Эстония: ohtuleht.ee | nami-nami.ee | hind.ee | swedbank.ee | tallinn.ee | eki.ee"
echo -e "Нидерланды: nu.nl | telegraaf.nl | funda.nl | buienradar.nl | rabobank.nl | rtl.nl"
echo -e "Швейцария: 20min.ch | search.ch | autoscout24.ch | local.ch | immoscout24.ch | mediamarkt.ch${NC}"
