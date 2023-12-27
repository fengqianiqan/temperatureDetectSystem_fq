##### 温湿度环境检测系统（简易）

- [如何在JAVA工程中导入web文件](https://blog.csdn.net/yuyunbai0917/article/details/122823288)

- 太久没运行发现没有run选项，配置Tomcat7,导入足够的库文件

  - [配置Artifcts参考网址](https://blog.csdn.net/weixin_45965432/article/details/111316470)

  - 点击 configuration配置tomcat7，加入Artifacts

  - 不要把任何包和文件“fix”到”Artifacts“里面，在class文件中反应的目录应该如下

    <img src="http://fqtypora-test.oss-cn-chengdu.aliyuncs.com/fqtypora-testimage-20231222081043441.png" alt="image-20231222081043441" style="zoom:50%;" />

- 如果出现setCharacterEncoding等报红错误，说明没有导入Library，导入Tomcat7和8的bin和lib，教程参考[setCharacterEncoding等报红错误](https://blog.csdn.net/weixin_55134726/article/details/123867053)

- 如果out.println报错：file->validate restart->only restart

- 如果报错：gno,io不存在

  - 将rxtxSerial.dll、rxtxParallel.dll复制到\jre\bin目录下。将RXTXcomm.jar复制到\jre\lib\ext目录下。还需要把rxtxParallel.dll、rxtxSerial.dll引入系统环境：C:\WINDOWS\system32下，重启IDEA即可

- 为了能正确运行传感器接收数据的接口文件：ContinueRead,配置如下<img src="http://fqtypora-test.oss-cn-chengdu.aliyuncs.com/fqtypora-testimage-20231221210504849.png" alt="image-20231221210504849" style="zoom:50%;" /><img src="http://fqtypora-test.oss-cn-chengdu.aliyuncs.com/fqtypora-testimage-20231221210944849.png" alt="image-20231221210944849" style="zoom:33%;" />

- 在运行Tomcat7的网址后面记得加入redirect.jsp

  <img src="http://fqtypora-test.oss-cn-chengdu.aliyuncs.com/fqtypora-testimage-20231221212541154.png" alt="image-20231221212541154" style="zoom:50%;" />

- 最后同时运行Tomcat7和ContinueRead，即可实现传感器接收的数据存储在mysql数据库，前端网页实现从mysql数据库每秒提取一次数据，刷新后显示在网页

- Navicat建表说明：<img src="http://fqtypora-test.oss-cn-chengdu.aliyuncs.com/fqtypora-testimage-20231221220310534.png" alt="image-20231221220310534" style="zoom: 67%;" />

  

  
