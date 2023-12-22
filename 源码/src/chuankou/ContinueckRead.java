package chuankou;

import java.io.*;
import java.util.*;
import java.util.Date;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import gnu.io.*;
import java.sql.*;
import java.awt.*;
import javax.swing.*;

public class ContinueckRead extends Thread implements SerialPortEventListener { // SerialPortEventListener
    // 监听器,我的理解是独立开辟一个线程监听串口数据
    static CommPortIdentifier portId; // 串口通信管理类
    static Enumeration<?> portList; // 有效连接上的端口的枚举
    InputStream inputStream; // 从串口来的输入流
    static OutputStream outputStream;// 向串口输出的流
    static SerialPort serialPort; // 串口的引用
    // 堵塞队列用来存放读到的数据
    private BlockingQueue<String> msgQueue = new LinkedBlockingQueue<String>();
    Connection ct = null;
    ResultSet rs = null;

    Toolkit toolkit=Toolkit.getDefaultToolkit();

    private static float wendu1;
    private static  float shidu1;
    private static  double w1;
    private static  double w2;
    private static  double s1;
    private static  double s2;
    private static  double wx;
    private static  double sx;
    JFrame f=new JFrame("环境温湿度检测");
    JButton button1=new JButton("温度：");
    JButton button2=new JButton("湿度：");
    JButton button3=new JButton("温度下界：");
    JButton button4=new JButton("温度上界：");
    JButton button5=new JButton("理想温度：");
    JButton button6=new JButton("湿度上界：");
    JButton button7=new JButton("湿度下界：");
    JButton button8=new JButton("理想湿度：");
    JTextField tf1;
    JTextField tf2;
    JTextField tf3;
    JTextField tf4;
    JTextField tf5;
    JTextField tf6;
    JTextField tf7;
    JTextField tf8;
    JTextField tf9;
    JTextField tf10;
    @Override
    /**
     * SerialPort EventListene 的方法,持续监听端口上是否有数据流
     */
    public void serialEvent(SerialPortEvent event) {//

        switch (event.getEventType()) {
            case SerialPortEvent.BI:
            case SerialPortEvent.OE:
            case SerialPortEvent.FE:
            case SerialPortEvent.PE:
            case SerialPortEvent.CD:
            case SerialPortEvent.CTS:
            case SerialPortEvent.DSR:
            case SerialPortEvent.RI:
            case SerialPortEvent.OUTPUT_BUFFER_EMPTY:
                break;
            case SerialPortEvent.DATA_AVAILABLE:// 当有可用数据时读取数据
                byte[] readBuffer = new byte[20];
                try {
                    int numBytes = -1;
                    while (inputStream.available() > 0) {
                        numBytes = inputStream.read(readBuffer);
                        StringBuilder sb = new StringBuilder();
                        for(byte b:readBuffer){
                            sb.append(String.format("%02x",b));
                        }
                        if (numBytes > 0) {
                            msgQueue.add(new Date() + "真实收到的数据为：-----"
                                    + new String(sb));
                            readBuffer = new byte[20];// 重新构造缓冲对象，否则有可能会影响接下来接收的数据
                        } else {
                            msgQueue.add("额------没有读到数据");
                        }
                    }
                } catch (IOException e) {
                }
                break;
        }
    }

    /**
     *
     * 通过程序打开COM4串口，设置监听器以及相关的参数
     *
     * @return 返回1 表示端口打开成功，返回 0表示端口打开失败
     */
    public int startComPort() {
        // 通过串口通信管理类获得当前连接上的串口列表
        portList = CommPortIdentifier.getPortIdentifiers();
        String url="jdbc:mysql://127.0.0.1:3306/zigbee1?characterEncoding=utf-8";
        String user="root";
        String password = "111111";
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e2) {
            // TODO Auto-generated catch block
            e2.printStackTrace();
        }
        try {
            ct=DriverManager.getConnection(url,user,password);
        } catch (SQLException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        while (portList.hasMoreElements()) {

            // 获取相应串口对象
            portId = (CommPortIdentifier) portList.nextElement();

            System.out.println("设备类型：--->" + portId.getPortType());
            System.out.println("设备名称：---->" + portId.getName());
            // 判断端口类型是否为串口
            if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
                // 判断如果COM4串口存在，就打开该串口
                if (portId.getName().equals("COM8")) {
                    try {
                        // 打开串口名字为COM_4(名字任意),延迟为2毫秒
                        serialPort = (SerialPort) portId.open("COM8", 2000);

                    } catch (PortInUseException e) {
                        e.printStackTrace();
                        return 0;
                    }
                    // 设置当前串口的输入输出流
                    try {
                        inputStream = serialPort.getInputStream();
                        outputStream = serialPort.getOutputStream();
                    } catch (IOException e) {
                        e.printStackTrace();
                        return 0;
                    }
                    // 给当前串口添加一个监听器
                    try {
                        serialPort.addEventListener(this);
                    } catch (TooManyListenersException e) {
                        e.printStackTrace();
                        return 0;
                    }
                    // 设置监听器生效，即：当有数据时通知
                    serialPort.notifyOnDataAvailable(true);

                    // 设置串口的一些读写参数
                    try {
                        // 比特率、数据位、停止位、奇偶校验位
                        serialPort.setSerialPortParams(115200,
                                SerialPort.DATABITS_8, SerialPort.STOPBITS_1,
                                SerialPort.PARITY_NONE);
                    } catch (UnsupportedCommOperationException e) {
                        e.printStackTrace();
                        return 0;
                    }

                    return 1;
                }
            }
        }
//        System.err.println("行 75 portId.getName().equals(\"COM4:USB-SERIAL\")判fasle");
        return 0;
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        try {
            int num=0;
            System.out.println("--------------任务处理线程运行了--------------");




            while (true) {
                // 如果堵塞队列中存在数据就将其输出
                if (msgQueue.size() > 0) {
                    num++;
                    Statement s=ct.createStatement();
                    String sql="insert into zigbee_receive_data (id,temperature,humidity,create_time) values('";
                    String get=msgQueue.take();
                    System.out.println(get);
                    String[] str1=get.split("真实收到的数据为：-----");
                    String id=str1[1].substring(4,6);
                    //温度
                    String tem_tmp=str1[1].substring(10,14);
                    Float temp_f=(float)Long.parseLong(tem_tmp,16)/100;
                    String temp=Float.toString(temp_f)+"℃";
//                    System.out.println(temp_f);
                    //湿度
                    String humid_tmp=str1[1].substring(14,18);
                    String humid=Float.toString((float)Long.parseLong(humid_tmp,16)/100)+"%";





                    System.out.println(humid);
                    if(temp_f>0&&temp_f<50) {
                        sql+=num+"','"+temp+"','"+humid+"','"+str1[0]+"')";
                        //System.out.println(sql);
                        s.executeUpdate(sql);
                        System.out.println(temp_f);
                        wendu1=temp_f;
                        shidu1=(float)Long.parseLong(humid_tmp,16)/100;
                        tf1.setText(String.valueOf((wendu1+"℃")));
                        tf2.setText(String.valueOf((shidu1+"%")));
                        if(wendu1>=w1&&wendu1<wx){
                            tf9.setText((String.valueOf("当前温度低于舒适温度")));
                        }else if(wendu1>wx&&wendu1<=w2) {
                            tf9.setText((String.valueOf("当前温度高于舒适温度")));
                        }else if(wendu1<wx||wendu1>w2){
                            tf9.setText((String.valueOf("当前温度超出范围")));
                            toolkit.beep();

                        } else{
                            tf9.setText((String.valueOf("当前温度适宜")));
                        }
                        if(shidu1>=s2&&shidu1<sx){
                            tf10.setText(String.valueOf("当前湿度小，干燥"));
                        }else if(shidu1>sx&&shidu1<=s1){
                            tf10.setText(String.valueOf("当前湿度大：潮湿"));
                        }else if(shidu1>s2||shidu1<s1){
                            tf10.setText(String.valueOf("当前湿度超出范围!!!"));
                            toolkit.beep();

                        }else{
                            tf10.setText(String.valueOf("当前湿度适宜"));
                        }

                        w1=Double.parseDouble(tf3.getText());
                        w2=Double.parseDouble(tf4.getText());
                        wx=Double.parseDouble(tf5.getText());
                        s1=Double.parseDouble(tf6.getText());
                        s2=Double.parseDouble(tf7.getText());
                        sx=Double.parseDouble(tf8.getText());

                    }
                    if(num%20==0){
                        s.executeUpdate("DELETE FROM zigbee_receive_data");
                    }
                }
            }
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void graphic(){
        f.setLayout(new FlowLayout((FlowLayout.LEFT)));

        tf3=new JTextField("20");
        tf4=new JTextField("40");
        tf5=new JTextField("20");
        tf6=new JTextField("50");
        tf7=new JTextField("30");
        tf8=new JTextField("40");
        f.add(button1);
        tf1=new JTextField("30");
        f.add(tf1);

        f.add(button2);
        tf2=new JTextField("30");
        f.add(tf2);

        f.add(button3);
        tf3.setColumns(3);
        f.add(tf3);

        f.add(button4);
        tf4.setColumns(3);
        f.add(tf4);

        f.add(button5);
        tf5.setColumns(20);
        f.add(tf5);

        f.add(button6);
        tf6.setColumns(3);
        f.add(tf6);

        f.add(button7);
        tf7.setColumns(3);
        f.add(tf7);

        f.add(button8);
        tf8.setColumns(20);
        f.add(tf8);

        tf9=new JTextField(25);
        f.add(tf9);

        tf10=new JTextField(25);
        f.add(tf10);

        f.setSize(400,300);
        f.setVisible(true);
    }
    public static void main(String[] args) {
        ContinueckRead cRead = new ContinueckRead();
        cRead.graphic();
        int i = cRead.startComPort();
        if (i == 1) {
            // 启动线程来处理收到的数据
            cRead.start();
            try {
                String st = "哈哈----你好";
                System.out.println("发出字节数：" + st.getBytes("gbk").length);
                outputStream.write(st.getBytes("gbk"), 0,
                        st.getBytes("gbk").length);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        } else {
            return;
        }
    }
}
