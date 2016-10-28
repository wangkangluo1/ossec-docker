##简介
ossec-docker 一个机遇docker的ossec server
##使用
#####创建数据库（如果使用已有数据，请直接忽略此操作）

```
# mysql -u root -p ossec < mysql.schema
```
[mysql.schema](https://github.com/user/repo/blob/branch/other_file.md)
或
wget http://roy-public.oss-cn-hangzhou.aliyuncs.com/mysql.schema

####运行ossec-server
 
```
# docker run --name ossec-server  -e MYSQL_SERVER=127.0.0.1 -e MYSQL_USERNAME=root -e MYSQL_PASSWORD=123456 -e MYSQL_DB=ossec --net=host -d wangkangluo1/ossec-docker
```
|变量||
|--------|--------|
|MYSQL_SERVER|mysql服务器地址|
|MYSQL_USERNAME|mysql用户名|
|MYSQL_PASSWORD|mysql密码|
|MYSQL_DB|数据库名|


#####访问UI: 
http://$your_ip/analogi
http://$your_ip/ossec

##构建
```
docker build -t ossec-server:$version ./
```
