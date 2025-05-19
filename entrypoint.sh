

echo "Aguardando o MySQL ficar disponível..."
until nc -z -v -w30 krayin_mysql 3306
do
  echo "⏳ Ainda aguardando o MySQL..."
  sleep 3
done

echo "MySQL está pronto - executando comandos de inicialização..."

composer install

composer create-project ...

php artisan krayin-crm:install

php artisan serve --host=0.0.0.0 --port=8000
