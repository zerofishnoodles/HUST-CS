import java.sql.*;

public class Transform {
  static final String JDBC_DRIVER = "org.postgresql.Driver";
    static final String DB_URL = "jdbc:postgresql://127.0.0.1:5432/postgres?";
    static final String USER = "gaussdb";
    static final String PASS = "Passwd123@123";
    
    /**
     * 向sc表中插入数据
     *
     */
    public static int insertSC(Connection conn, int sno, String col, int val){
			PreparedStatement ps = null;
			int n = 0;
			try {
				String sql = "insert into sc values(?,?,?)";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, sno);
				ps.setString(2, col);
				ps.setString(3, Integer.toString(val));
				n = ps.executeUpdate();
			}catch(SQLException e){
				e.printStackTrace();
			}finally {
				try{
					if(ps != null) {
						ps.close();
					}
				}catch	(SQLException throwables) {
                	throwables.printStackTrace();
            	}
			}
			return 1;
    }

    public static void main(String[] args) throws Exception{

			Class.forName(JDBC_DRIVER);

      Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);

			String sql = "select * from entrance_exam";
			Statement stmt = conn.createStatement();

			int n = 0;

			try {
				ResultSet rs = stmt.executeQuery(sql);
				ResultSetMetaData rsmd = rs.getMetaData();
				while(rs.next()) {
					for(int i=2; i<=rsmd.getColumnCount(); i++) {
						if(rs.getInt(i) != 0){
							n = insertSC(conn, rs.getInt("sno"),rsmd.getColumnName(i), rs.getInt(i));
						}
				}
				}
			}catch (SQLException e){
				System.out.print("error");
			}



    }
}