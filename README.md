# 📦 Развёртывание Python-микросервиса на VirtualBox с min ISO Alma Linux 9.5 с помощью Ansible и Docker


## 🛠 Требования

- VirtualBox с запущенной VM на AlmaLinux 9
- Ansible должен быть установлен на хостовой системе
- SSH-доступ к VM
- Docker должен быть вручную установлен на VM
- Python version >= 3.9
- Рабочее подключение к интернету на VM (в моем случае использовалось два адаптера: NAT и Сетевой мост)


## Автоматизация доступа к SSH-ключу (ОПЦИОНАЛЬНО)

Чтобы постоянно не вводить passphrase перед запуском плейбука, воспользуйтесь agent_init.sh, который запускает
SSH-agentа на время работы сессии.

```bash
./agent_init.sh
```

## 🚀 Запуск роли Ansible

Перед выполнением указать режим сборки в переменной deploy_method (./deploy_microservice/defaults/main.yml):
- "default" — обычное приложение
- "docker" — запуск как Docker-контейнер

#defaults file for deploy_microservice
app_name: "server.py"
app_dir: "/home/admin"
app_port: 8080
deploy_method: "docker"

Запуск плейбука:
```bash
ansible-playbook playbook.yml
```


# 🐳 Сборка и запуск Docker вручную (for debugging)

Перейди на VM и выполнить:

```bash
cd /home/admin/container
docker build -t server .
docker run -d -p 8080:8080 --name service-container server
```

🔍 Проверка

Открой в браузере на хост-машине:
```bash
http://<ip_vm>:8080
```
Так же можно проверить на целевом сервере:
```bash
http://localhost:8080
```

Ожидаемый вывод:
```bash
# HELP CPU_usage CPU usage in percentage
# TYPE CPU_usage gauge
CPU_usage 0.4
# HELP RAM_usage RAM usage in percentage
# TYPE RAM_usage gauge
RAM_usage 22.61
# HELP Disk_usage Disk usage in percentage
# TYPE Disk_usage gauge
Disk_usage 1.3
# HELP host_type Type of host environment
# TYPE host_type gauge
host_type{type="physical_server"} 1.0
```

📌 Особенности

Для доступа Ansible к паролю от sudo пользователя admin (целевого сервера) используется шифрование при помощи ansible-vault в целях безопасности.
пароль от Ansible-vault хранится вне директории проекта в формате файла .ansible_password_file.txt 
