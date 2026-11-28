# Автоматический бэкап на Bash
Скрипт архивирует учебную папку $HOME/study/week4/tue/backup-demo. По умолчанию он сохраняет архивы в $HOME/study-backups.
Чтобы выбрать другой каталог, передайте переменную BACKUP_DIR при запуске.


## Проверка восстановления

После пробного запуска выберите нужный архив в `test-backups`.
Запустите команды из папки проекта и подставьте дату своего архива.

```bash
archive="$PWD/test-backups/backup-demo-2026-11-28.tar.gz"
restore_dir=$(mktemp -d "$PWD/restore.XXXXXX")

tar -xzf "$archive" -C "$restore_dir" &&
cmp "$HOME/study/week4/tue/backup-demo/note.txt" \
    "$restore_dir/backup-demo/note.txt"
echo "$?"
```

Код `0` означает, что архив распаковался и восстановленный файл
совпадает с исходным байт в байт

## Подготовка и ручной запуск

demo_dir="$HOME/study/week4/tue/backup-demo"
mkdir -p "$demo_dir"
if [ ! -e "$demo_dir/note.txt" ]; then
    printf 'Тестовый файл для бэкапа\n' > "$demo_dir/note.txt"
fi

# Выполните из папки, где лежит backup.sh
BACKUP_DIR="$PWD/test-backups" bash backup.sh

Запуск по расписанию

0 2 * * * /usr/bin/bash "$HOME/devops-notes/linux/backup-project/backup.sh" >> "$HOME/backup.log" 2>&1
