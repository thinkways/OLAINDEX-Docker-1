# OLAINDEX-Docker

## OLAINDEX

https://github.com/WangNingkai/OLAINDEX

## 主要修改

此Dockerfile主要修复两个问题：
在外部Nginx开启https与HSTS后，
1) 在初始化绑定账号时采用http发送POST请求被拒绝，导致无法绑定账号；
2) 图床上传文件时采用http发送POST请求被拒绝，导致无法上传图片

处理方法参照了[这个issue](https://github.com/WangNingkai/OLAINDEX/issues/63)  
写的东西比较粗糙，但能用

## 最简设置

1. 修改.env文件
```bash
cp .env.example .env
```
参照 https://github.com/WangNingkai/OLAINDEX/blob/master/.env.example

2. 数据库
```bash
touch db/database.sqlite
```

3. 构建/启动
```bash
docker-compose up --build -d
```

4. 初始化
```bash
docker-compose exec core php artisan key:generate
docker-compose exec core php artisan od:install
docker-compose exec core php artisan cache:clear
```

参照了[wsenh的repo](https://github.com/wsenh/olaindex-docker)
