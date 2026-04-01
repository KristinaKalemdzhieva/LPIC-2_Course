# Изграждане на лаборатория: Infrastructure as Code


## Стъпка 1: Регистрация в портала на Broadcom
За достъп до софтуера е необходима регистрация в системата на Broadcom.

1. Посетете [страницата за регистрация](https://profile.broadcom.com/web/registration).
2. Използвайте валиден имейл адрес и потвърдете профила си чрез предоставения код.
3. **Важно:** Въведете коректни данни за адрес и държава. Неточните данни могат да доведат до неуспешна проверка за експортен контрол (Export Compliance) и блокиране на достъпа до изтеглянията.


## Стъпка 2: Инсталиране на VMware

### Инструкции за изтегляне
При опит за изтегляне на софтуера, чекбоксът за съгласие с "Terms and Conditions" първоначално е деактивиран. За да го отключите:
1. Кликнете върху хипервръзката **Terms and Conditions**.
2. Тя ще се зареди в нов раздел (tab) на браузъра.
3. Върнете се в предходния раздел – чекбоксът вече ще бъде активен за маркиране, което ще позволи изтеглянето на файла.

### За потребители на macOS (Apple Silicon и Intel)
1. Влезте в [Broadcom Support Portal](https://support.broadcom.com/) и изберете **My Downloads**.
2. Намерете **VMware Fusion** (версия 13.5.2 или по-нова).
3. Изберете опцията за **Personal Use**.
4. Инсталирайте файла и при активиране изберете "I want to license VMware Fusion Pro for Personal Use".

### За потребители на Windows
1. Влезте в [Broadcom Support Portal](https://support.broadcom.com/) и изберете **My Downloads**.
2. Намерете **VMware Workstation Pro** (версия 17.5.2 или по-нова).
3. Изтеглете инсталационния файл чрез синята стрелка.
4. След приключване на инсталацията изберете опцията за **Personal Use / Finish**.


## Стъпка 3: Инсталиране на Vagrant и компоненти

### За потребители на Mac (чрез Homebrew)

1. Отворете Terminal и инсталирайте Vagrant:
   ```bash
   brew install vagrant
   ```

2. Инсталирайте Vagrant VMware Utility (критичен компонент):
   ```bash
   brew install vagrant-vmware-utility
   ```

3. Инсталирайте плъгина за Vagrant:
   ```bash
   vagrant plugin install vagrant-vmware-desktop
   ```

4. Специфично за Apple Silicon: Инсталирайте Rosetta 2 (ако още нямате):
   ```bash
   /usr/sbin/softwareupdate --install-rosetta --agree-to-license
   ```

### За потребители на Windows

1. Изтеглете и инсталирайте Vagrant от [официалния сайт](https://developer.hashicorp.com/vagrant/install).

2. Изтеглете и инсталирайте Vagrant VMware Utility за Windows.

3. Отворете PowerShell (като администратор) и инсталирайте плъгина:

   ```powershell
   vagrant plugin install vagrant-vmware-desktop
   ```

## Стъпка 4: Рестарт

Задължително трябва да рестартирате компютрите си след тези инсталации. Това е необходимо, за да може Vagrant VMware Utility да активира виртуалните мрежови устройства. Без рестарт `vagrant up` често дава грешка при опит за създаване на мрежов адаптер.


## Стъпка 5: Проверка

Проверете дали всичко е наред с командата:
```bash
vagrant plugin list
```

Трябва да видите в списъка: `vagrant-vmware-desktop`.\
Ако го виждате – всичко е наред.

## Стъпка 6: Създаване на Vagrantfile

1. Създайте папка за курса (напр. LPIC2_Lab).
2. В папката добавете файла Vagrantfile.

**Забележка:** Не е нужно да пишете съдържанието ръчно — използвайте Vagrantfile-а, който е предоставен по-горе в инструкциите.

Този файл вече съдържа конфигурацията за:
- Ubuntu сървър (node1)
- Rocky Linux сървър (node2)
- Настройка на VMware провайдера и частната мрежа
- Поддръжка за Apple Silicon, ако е приложимо

## Стъпка 7: Вдигане на машините

1. Стартиране на терминала

Отворете PowerShell (Windows) или Terminal (Mac) и влезте в папката, където се намира `Vagrantfile`.

2. Команда за старт

Изпълнете:
```bash
vagrant up
```

**Забележка:**
Тъй като всички използват VMware, Vagrant автоматично ще открие провайдъра.
Ако имате инсталиран и VirtualBox, може да форсирате VMware с:
```bash
vagrant up --provider vmware_desktop
```

3. Влизане в машините

- За Ubuntu:
    ```bash
    vagrant ssh node1
    ```

- За Rocky Linux:
    ```bash
    vagrant ssh node2
    ```

4. Излизане от машините
   
За да се върнете обратно в нормалния терминал:
```bash
exit
```
или използвайте: `Ctrl + D`

5. Изключване на машините
- Спиране:
    ```bash
    vagrant halt
    ```

- Приспиване на машините (спиране без изключване):
    ```bash
    vagrant suspend
    ```

    **Важно:** След преспиване машините се стартират чрез:
    ```bash
    vagrant resume
    ```

- Изтриване на машините:
    ```bash
    vagrant destroy
    ```
