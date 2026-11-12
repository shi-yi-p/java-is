import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
public class BcryptCheck {
    public static void main(String[] args) {
        BCryptPasswordEncoder e = new BCryptPasswordEncoder();
        String h1 = "$2a$10$8l6XelQnMQTA9imAdbu6vuue4h7kyQNiUWBzx1nS/G/KXTLHqrgTe";
        String h2 = "$2a$10$D9Qx/qGr2u.xYIz5QJ2/COZ8bZJZcoOFGavgQpvAsIQ2BN/2MSs7K";
        String[] cands = {"123","123456","12345678","111","111111","admin","admin123","password","888888","666666","abc123","123123","11111111","qwerty","1234567","root","1234"};
        System.out.println("=== 哈希1 (account=123) ===");
        boolean f1=false;
        for (String c : cands) if (e.matches(c, h1)) { System.out.println("匹配: " + c); f1=true; }
        if(!f1) System.out.println("(常见密码均不匹配)");
        System.out.println("=== 哈希2 (account=111) ===");
        boolean f2=false;
        for (String c : cands) if (e.matches(c, h2)) { System.out.println("匹配: " + c); f2=true; }
        if(!f2) System.out.println("(常见密码均不匹配)");
    }
}
