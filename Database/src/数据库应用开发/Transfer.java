import java.sql.*;
import java.util.Scanner;

public class Transfer {
    static final String JDBC_DRIVER = "org.postgresql.Driver";
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/postgres?";
    static final String USER = "gaussdb";
    static final String PASS = "Passwd123@123";
    /**
     * 转账操作
     *
     * @param connection 数据库连接对象
     * @param sourceCard 转出账号
     * @param destCard 转入账号
     * @param amount  转账金额
     * @return boolean
     *   true  - 转账成功
     *   false - 转账失败
     */
    public static boolean transferBalance(Connection connection,
                             String sourceCard,
                             String destCard, 
                             double amount){
		PreparedStatement ps = null;
		ResultSet rs = null;
		int n = 0;
		boolean res = false;
		try{
			connection.setAutoCommit(false);
			String sql = "select b2.b_type as b_type from bank_card b1, bank_card b2  where b1.b_number = ? and b1.b_type != '信用卡' and b1.b_balance >= ? and b2.b_number = ? ";
			ps = connection.prepareStatement(sql);
			ps.setString(1,sourceCard);
			ps.setDouble(2,amount);
			ps.setString(3,destCard);
			rs = ps.executeQuery();
			if(rs.next()){
				if(rs.getString("b_type").trim().compareTo("储蓄卡") == 0){
					
					sql = "update bank_card set b_balance = b_balance + ? where b_number = ?";
					ps = connection.prepareStatement(sql);
					ps.setString(2,destCard);
					ps.setDouble(1,amount);
					n = ps.executeUpdate();
				}else{
					sql = "update bank_card set b_balance = b_balance - ? where b_number = ?";
					ps = connection.prepareStatement(sql);
					ps.setString(2,destCard);
					ps.setDouble(1,amount);
					n = ps.executeUpdate();
				}


				sql = "update bank_card set b_balance = b_balance - ? where b_number = ?";
				ps = connection.prepareStatement(sql);
				ps.setString(2,sourceCard);
				ps.setDouble(1,amount);
				n = ps.executeUpdate();

				connection.commit();
				res = true;
			}else{
				try{
					connection.rollback();
	
				}catch (SQLException throwables_roll) {
                	throwables_roll.printStackTrace();
				}
			}
		}catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
				if(rs != null) {
					rs.close();
				}
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
		}
		
		return res;

    }

    // 不要修改main() 
    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);
        Class.forName(JDBC_DRIVER);

        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);

        while(sc.hasNext())
        {
            String input = sc.nextLine();
            if(input.equals(""))
                break;

            String[]commands = input.split(" ");
            if(commands.length ==0)
                break;
            String payerCard = commands[0];
            String  payeeCard = commands[1];
            double  amount = Double.parseDouble(commands[2]);
            if (transferBalance(connection, payerCard, payeeCard, amount)) {
              System.out.println("转账成功。" );
            } else {
              System.out.println("转账失败,请核对卡号，卡类型及卡余额!");
            }
        }
    }

}
