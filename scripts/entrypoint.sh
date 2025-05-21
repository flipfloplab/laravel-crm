echo "Aguardando o MySQL ficar disponível..."
until nc -z -v -w30 krayin_mysql 3306
do
  echo "⏳ Ainda aguardando o MySQL..."
  sleep 3
done

echo "MySQL está pronto - executando comandos de inicialização..."

INSTALLED=$(mysql --skip-ssl -h krayin_mysql -u root -p"Flip123@" -D laravel-crm -e "SHOW TABLES LIKE 'core_config';" | grep core_config)

echo "INSTALLED=$INSTALLED"

if echo "$INSTALLED" | grep -q "core_config"; then
  echo "Krayin já está instalado. Pulando instalação..."
else
  echo "Krayin ainda não instalado. Executando instalação..."
  echo "======================================"

  composer install

  composer create-project ...

  php artisan krayin-crm:install

  #CONFIGURAÇÕES API 
  echo "Iniciando configuração da API"
  echo "======================================"
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  echo "nameserver 8.8.4.4" >> /etc/resolv.conf

  composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer/

  composer clear-cache

  composer require krayin/rest-api -vvv

  php artisan krayin-rest-api:install 

  #CONFIGURAÇÕES MULTI TENANT
  echo "Iniciando configuração do Multi Tenant"
  echo "======================================"
  
  composer require stancl/tenancy
  php artisan db:seed

fi

php artisan serve --host=0.0.0.0 --port=8000


