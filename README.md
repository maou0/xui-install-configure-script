# xui-install-configure-script
# Описание
Данный скрипт произведет установку панели 3x-ui (xray vless reality) из официального репозитория автора:\
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
2. Наличие DNS A записи для ip адреса VSP сервера. Бесплатный домен 3 уровня с А записью можно получить у [DUCK DNS](https://www.duckdns.org/). Залогиниться можно через google аккаунт (если переживаете, создайте отдельный google аккаунт).

Примеры хостингов для покупки VPS с карты МИР (СБП):
- [WeaselCloud](https://my.weasel.cloud/)
- [Inferno Solutions](https://cp.inferno.name/index.php)
- [is*hosting](https://my.ishosting.com/ru)
- [PQ.Hosting](https://bill.pq.hosting/)
- [Aeza](https://aeza.net/)

# Личный опыт использования VPS серверов
В поиске сервера с минимальной задержкой мной были опробованы более десятка хостинг провайдеров. Данный опыт актуален для Москвы (и ближнее Подмосковье), интернет провайдеры - Риалком (пользуется сетями Ростелекома), мобильный Мегафон, мобильный МТС. Были опробованы сервера в Финляндии, Германии, Нидерландах, Эстонии, Швейцарии. 
Из всех стран, ниже всего задержка оказалась в Эстонии. Финляндия самый худший вариант, т.к. через нее многие ресурсы недоступны - НЕ РЕКОМЕНДУЮ. Соответственно далее тестировал задержку именно серверов в Эстонии, вот результаты по провайдерам (у aeza, к сожалению, серверов в Эстонии нет):

### Риалком (Ростелеком) 
1. WeaselCloud
2. Inferno Solutions
3. is*hosting

### Мегафон мобильный
1. is*hosting
2. Inferno Solutions
3. PQ.Hosting | 4VPS (одинаковые результаты)

### МТС мобильный
1. Inferno Solutions
2. PQ.Hosting
3. WeaselCloud

### Дополнительная информация
- WeaselCloud на домашнем интернете оказался фаворит, причем дает большую фору большинству остальных, самое стабильное подключение к Эстонскому серверу, также имеется возможность переустанавливать ОС на серверах без помощи ТП, а вот на мобильном интернете показал себя слабо. Есть еще большое НО, которое скорее всего заставит меня отказаться от их услуг - они практически не реагируют на запросы в ТП. VPS, который я у них арендую в Нидерландах, помер, не получается переустановить ОС, она просто виснет. Прошла неделя после обращения в ТП, а реакции ноль. 
- У Aeza очень понравился современный интерфейс личного кабинета, можно самому переустанавливать ОС, очень приятный сервис, НО. Серверов в Эстонии нет, сервера в Германии кончились, остаются только Нидерданды, но пинг до сервера в Нидерландах почти в 2 раза выше, чем до серверов в Эстонии. Вернусь к ним, если появятся сервера в Германии.
- Пока что золотой серединой выглядит Inferno Solutions, НО. У них страшно устаревший сайт, для переустановки ОС надо обращаться в ТП. Если поставить 3x-ui один раз и забыть, то на минусы можно закрыть глаза. Задержка не сильно выше, чем у WeaselCloud, но менее стабильное.
- Оптимальным вариантом выглядит покупка двух серверов, по серверу у разных хостинг провайдеров. Один из серверов должен определенно быть в Эстонии (думаю пока оставить Inferno Solutions), второй в качестве перестраховки лучше взять в другой стране, пока остановился на Нидерландах (*), но возможно переберусь в Германию (когда у Aeza появятся там сервера).

# Установка и настройка сервера xray
Получив данные для входа на VPS сервер (обычно присылают на почту после оплаты) в терминале (Linux/MacOS) или powershell (Windows) вводим команду чтобы войти на сервер по ssh:
```
ssh root@45.82.253.40
```
где root - имя пользователя, 45.82.253.40 - ip адрес сервера, на запрос пароля - вводим полученный пароль из почты.

Выполняем команду на VPS сервере:
```
/bin/bash <(curl -Ls https://raw.githubusercontent.com/maou0/xui-install-configure-script/refs/heads/main/xui-install-configure.sh)
```
Будет запрошен домен, введите домена вида: example.duckdns.org\
Затем будет запрошено подтверждение чтобы продолжить. Если согласны, введите: y

Дождитесь завершения установки и сохраните в надежное место все данные, которые предоставит скрипт:
![image](https://github.com/user-attachments/assets/eab96115-bebd-4617-91a5-1d83ef660d43)

Теперь в панель можно попасть по ссылке: https://blockerino.duckdns.org:34067/g5tjP4tk1IWwCKA  
Соединение уже будет безопасным, с использованием ssl сертификата.\
Логины, пароли, а также адрес и порт панели генерируются случайный образом при каждой установке, поэтому не обязательно их менять.

Заходите в панель и сделайте 2 настройки:
1. Перейдите Xray Configs -> Basics -> Basic Routing, добавьте опцию 'Russia' в поле 'Block IPs' и опции 'Russia', '.ru' в поле 'Block Domains'. После этого нажмите кнопки 'Save' и 'Restart Xray' вверху страницы. Это заблокирует нам подключение к сайта и РУ зоны с нашего сервера.

![image](https://github.com/user-attachments/assets/c8ca165e-7369-4b42-b9e4-515adf36296c)

2. Теперь надо выбрать сайт для маскировки. По завершению скрипта приведены сайты, которые можно использовать, но при желании также можно подобрать сайт самостоятельно.\
Критериев подбора 2:
- сайт не должен быть заблокирван в России (у вас должна быть возможность его открыть без средств обхода блокировок)
- сайт должен находиться в той же зоне, что и VPS сервер. Например, для Эстонского VPS надо искать сайт в зоне .ee
- задержка на VPS сервере до сайта не должна быть высокой (найти с сайт с задержкой менее 5ms довольно просто)
- подобрать популярный сайт для определенной страны можно через [сервиc](https://ahrefs.com/websites)

![image](https://github.com/user-attachments/assets/6865bc5f-351e-41a4-8db9-dd1649ebf74c)

3. Перейдите в Inbounds, нажмите add inbound.
4. В появившемся окне поменяйте значения:
- Remark: любое название, для удобства обычно называю по имени хостинг провайдера и страны, где арендован VPS сервер
- Listen IP: ip адрес VPS сервера, на котором запускался скрипт
- Port: 443
- Security: выбираем Reality, после этого у нас в блоке Client появится выбор параметра Flow
- Раскрываем блок Client, в поле Email пишем что угодно, для удобства можно писать имя устройства (iPhone, Notebook, LenovoTablet), в поле Flow выбираем xtls-rprx-vision
- Dest (Target): доменное имя сайта, под который маскируемся, с портом 443, например, для сайта https://eki.ee это будет eki.ee:443
- SNI: например, для сайта https://eki.ee это будет eki.ee,www.eki.ee
- Нажимаем большую кнопку Get New Cert
- Остальные параметры оставляем без изменений и жмем кнопку Create

![image](https://github.com/user-attachments/assets/00451bf6-4eb8-40cc-8f8d-d1c75f489665)
![image](https://github.com/user-attachments/assets/19a7914d-952f-40d2-ae14-80f74cad3405)

5. Для каждого устройства рекомендуется создать дополнительного клиента. Для этого в разделе Inbounds находим в списке только что созданный  Inbound (он у нас всего один) и нажимаем на 3 точки под столбцом Menu -> Add Client
![image](https://github.com/user-attachments/assets/dd127929-8f9a-45c5-bd71-17cf7bfd9c6d)

6. В появившемся окне в поле Email пишем название устройства (iPhone, Notebook, LenovoTablet), а в поле Flow выбираем xtls-rprx-vision и нажимаем Add Client

![image](https://github.com/user-attachments/assets/1cc65790-d15c-424e-baf8-44985ef4c788)

7. (Необязательно) Чтобы сделать подключение к нашему VPS серверу еще безопасней, можно отключить возможность входа по паролю и ходить по ключам. Но учтите, что в случае утери ключа (например, при переустановке ОС) вы потеряете доступ к серверу по ssh.

Linux/MacOS.

Вводим следующие команды в терминал (вторая и третья команда будут отличаться, подставьте свои значения)
```
ssh-keygen -t ed25519
```
```
knock 45.82.253.40 11001 12002 13003 -d 500 && ssh-copy-id -p 26007 qogprthd@45.82.253.40
```
Теперь заходим на сервер по ключу:
```
knock 45.82.253.40 11001 12002 13003 -d 500 && ssh -p 26007 qogprthd@45.82.253.40
```
Вводим команды:
```
sudo -i
```
```
sed -i "/PubkeyAuthentication/c\PubkeyAuthentication yes" /etc/ssh/sshd_config && sed -i "/PasswordAuthentication/c\PasswordAuthentication no" /etc/ssh/sshd_config && systemctl restart ssh
```
Windows.

#TODO

На этом настройка сервера завершена, теперь нужно установить клиентские программы на свои устройства для подключения к xray серверу.

# Выбор клиентов для подключения
## Linux | Windows | MacOS | Android
[Hiddify Next](https://github.com/hiddify/hiddify-app)  
[Google play](https://play.google.com/store/apps/details?id=app.hiddify.com)

Есть для всех платформ, кроме iOS.

![image](https://github.com/user-attachments/assets/dbb717d7-79d9-474c-a7bb-90c5da65884f)

## iOS | MacOS
[FoXray](https://apps.apple.com/ru/app/foxray/id6448898396)

![image](https://github.com/user-attachments/assets/9108a17b-9a5d-45d9-abf6-a9246dacda9c)

# Настройка клиентов
## Hiddify
1. Зайдите в панель 3x-ui -> Inbounds -> нажмите на плюсик -> из списка у одного из созданных клиентов нажмите кружок с i -> скопируйте ссылку для подключения

![image](https://github.com/user-attachments/assets/99a47fbe-07e1-404c-b228-8a385a0c915a)

![image](https://github.com/user-attachments/assets/21051814-ba36-4aef-baf1-86dd36fe274d)

![image](https://github.com/user-attachments/assets/5722bc97-c45b-40d2-9f67-7e62b2dbd8db)

2. Запустите клиент Hiddify -> нажмите на плюсик -> Add From Clipboard

![image](https://github.com/user-attachments/assets/78296801-e294-47f9-9560-f265ed566c3c)

![image](https://github.com/user-attachments/assets/17ff0f40-e8d5-4d68-8b08-a81c809e8309)

3. Мобильные устройства можно подключать отсканировав QR код

![image](https://github.com/user-attachments/assets/8ed72fbc-1495-4ff5-920f-37ecda20e64a)

![image](https://github.com/user-attachments/assets/4aef10c0-f560-4f7d-a187-12e85de34476)

### ВАЖНО!
Крутая возможность в мобильной версии Hiddify (такой функционал есть и в других клиентах на android, типа Amnesia VPN, но мы их не рассматриваем) - это возможность запретить отдельным приложениям пользоваться Hiddefy, таким образом к российским приложениям (ozon, yandex, ЕМИАС, госуслуги и тп) мы сможем подключаться напрямую через провайдера. ОБЯЗАТЕЛЬНО СДЕЛАЙТЕ ЭТУ НАСТРОЙКУ так мы сможем пользоваться российскими приложениями с активным подключением, не боясь спалить наш ip адрес. По сути подключение в Hiddefy можно вообще не выключать.

Для этого переходим в Settings -> Per-App Proxy (активируем ползунок и проваливаемся внутрь) -> активируем опцию Do not Proxy Selected Apps -> ставим галочки напротив всех российских приложений в системе, также имеет смысл ставить галочки напротив игр, чтобы трафик для них ходил через провайдера и не повышал пинг.

![image](https://github.com/user-attachments/assets/a3859eaa-939b-4325-8518-a5f42633f4bc)

![image](https://github.com/user-attachments/assets/867376ec-89fd-4c31-a5b9-0a9065679f12)

![image](https://github.com/user-attachments/assets/99d8261a-3565-4d0d-bc28-99e51ce608ef)

![image](https://github.com/user-attachments/assets/17834727-f776-4645-8212-7888d57b14d1)


4. Мы заблокировали доступ к сайтам из РУ зоны на сервере, чтобы ходить на эти сайты напрямую через провайдера, перейдите в Config options -> в пункте Region поставьте Russia (ru)

![image](https://github.com/user-attachments/assets/8ae83a1a-135d-4950-9301-158b864d33b3)

5. Активируйте подключение.

![image](https://github.com/user-attachments/assets/d8bace2c-e8d2-4809-88b5-c5a051ed8c45)

![image](https://github.com/user-attachments/assets/947b4207-2f8b-40e9-a3f9-172e7ac7307d)


## FoXray

1. Зайдите в панель 3x-ui -> Inbounds -> нажмите на плюсик -> из списка у одного из созданных клиентов нажмите QR код, как в пункте 3 настройки Hiddify
2. Запустите клиент FoXray -> нажмите на значок сканирования QR кода и отсканируйте QR код из панели 3x-ui

![image](https://github.com/user-attachments/assets/51e63698-3fde-4f1a-b440-4df4e48a39b9)

3. Мы заблокировали доступ к сайтам из РУ зоны на сервере, чтобы ходить на эти сайты напрямую через провайдера, перейдите в Simple -> поставить галочку и нажать на Simple -> настройки как на скриншоте -> Save внизу страницы

![image](https://github.com/user-attachments/assets/f33b6186-914a-416f-adaf-246b43a9402d)

![image](https://github.com/user-attachments/assets/1a53c6a8-4be7-457d-abc9-074f6d8c463a)

![image](https://github.com/user-attachments/assets/d369d56f-1593-4968-adf6-6fc0fc56679e)

4. Активируйте подключение.

![image](https://github.com/user-attachments/assets/f4748b9d-1087-44ef-9467-63766dd9fa1c)

### ВАЖНО!
Не включайте российские приложения (ozon, yandex, ЕМИАС, госуслуги и тп) с активным подключением в FoXray, это спалит ваш ip адрес!

