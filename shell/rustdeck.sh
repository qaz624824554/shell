# 获取当前服务器的外网ip

ip=$(curl -s https://ipinfo.io/ip)

# 检测是否有安装 docker，没有则提示用户没有安装并返回

if ! [ -x "$(command -v docker)" ]; then
    echo "Docker is not installed, please install docker first."
    exit 1
fi

# 检测是否有安装 docker-compose，没有则提示用户没有安装并返回

if ! [ -x "$(command -v docker compose)" ]; then
    echo "Docker-compose is not installed, please install docker-compose first."
    exit 1
fi

# 安装 rustdeck

mkdir ./rustdeck

cd ./rustdeck

touch docker-compose.yml

echo "version: '3'

services:
  hbbs:
    container_name: hbbs
    image: rustdesk/rustdesk-server:latest
    command: hbbs -r $ip
    volumes:
      - ./data:/root
    network_mode: "host"

    depends_on:
      - hbbr
    restart: always


  hbbr:
    container_name: hbbr
    image: rustdesk/rustdesk-server:latest
    command: hbbr
    volumes:
      - ./data:/root
    network_mode: "host"
    restart: always
" >docker-compose.yml

docker compose up -d

echo "rustdeck 部署成功，Key为：$(find . -name *.pub -exec cat {} \;)"
