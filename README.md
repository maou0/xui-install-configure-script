# xui-install-configure-script
Данный скрипт произведет установку панели 3x-ui из официального репозитория автора:\
https://github.com/MHSanaei/3x-ui  

Помимо установки панели, будет произведена базовая настройка сервера, а именно:
- отключена возможность зайти по ssh для пользователя root
- порт ssh будет изменен, а также закрыт по умолчанию, для открытия порта используется port knocking\
Linux/MacOS: утилита knock\
Windows: стучаться будем скриптом\
Команда для knock и скрипт для Windows будут выведены скриптом.
- cоздан отдельный пользователь с правами sudo для доступа на сервер по ssh
- выпущены сертификаты от Let's Encrypt
- обновления безопасности Ubuntu, панель 3x-ui, а также сертификаты - будут автоматически обновляться systemd сервисом
- включен BBR в меню 3x-ui

Требования перед установкой:
1. VPS сервер в Европе с ОС Ubuntu 22.04 или новее. Рекомендуемые страны - Эстония, Германия, Нидерланды, Швейцария. Установка должна производиться на чистую ОС.
2. Наличие DNS A записи для ip адреса VSP сервера. Бесплатный домен 3 уровня с А записью можно получить у [DUCK DNS](https://www.duckdns.org/). Залогиниться можно через google аккаунт (если переживаете, создайте отдельный google аккаунт).\

Примеры хостингов для покупки VPS с карты МИР (СБП):\
- [WeaselCloud](https://my.weasel.cloud/)
- [Inferno Solutions](https://cp.inferno.name/index.php)
- [is*hosting](https://my.ishosting.com/ru)
- [PQ.Hosting](https://bill.pq.hosting/)
- [Aeza](https://aeza.net/)

Выполнить команду на VPS сервере:
```
/bin/bash <(curl -Ls https://raw.githubusercontent.com/maou0/xui-install-configure-script/refs/heads/main/xui-install-configure.sh)
```
Будет запрошен домен, введите домена вида: example.duckdns.org\
Затем будет запрощено подтверждение, отвечайте: y\

Дождитесь завершения установки и сохраните в надежное место все данные, которые предоставит скрипт:
![image](https://github.com/user-attachments/assets/eab96115-bebd-4617-91a5-1d83ef660d43)

Теперь в панель можно попасть по ссылке: https://blockerino.duckdns.org:34067/g5tjP4tk1IWwCKA  
Соединение уже будет безопасным, с использованием ssl сертификата.\
Логины, пароли, а также адрес и порт панели генерируются случайный образом при каждой установке, поэтому не обязательно их менять.\

Заходите в панель и сделайте 2 настройки:
1. Перейдите Xray Configs -> Basics -> Basic Routing, добавьте опцию 'Russia' в поле 'Block IPs' и опции 'Russia', '.ru' в поле 'Block Domains'. После этого нажмите кнопки 'Save' и 'Restart Xray' вверху страницы.

![image](https://github.com/user-attachments/assets/c8ca165e-7369-4b42-b9e4-515adf36296c)
