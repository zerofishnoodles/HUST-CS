import java.sql.*;
import java.util.Scanner;

public class Login {
    public static void main(String[] args) {
        Connection connection = null;
        //申明下文中的resultSet, statement
		PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;


        Scanner input = new Scanner(System.in);

        System.out.print("请输入用户名：");
        String loginName = input.nextLine();
        System.out.print("请输入密码：");
        String loginPass = input.nextLine();

        try {
            Class.forName("org.postgresql.Driver");
            String userName = "gaussdb";
            String passWord = "Passwd123@123";
            String url = "jdbc:postgresql://localhost:5432/postgres";
           
            connection = DriverManager.getConnection(url, userName, passWord);
          
            connection = DriverManager.getConnection(url, userName, passWord);
            // 补充实现代码:

			String sql = "select * from client where c_mail = ? and c_password = ?;"; 
			preparedStatement = connection.prepareStatement(sql);  
			preparedStatement.setString(1,loginName);  
			preparedStatement.setString(2,loginPass);  
			resultSet = preparedStatement.executeQuery(); 

			int flag = 0;
			while(resultSet.next()) {
				flag =1;
				System.out.println("登录成功。");
			}
			if(flag  == 0) {
				System.out.println("用户名或密码错误！");
			}




            

         } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }

                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
