package model;

public class User {
    private String userId;         // user_id
    private String userName;       // user_name (旧: name)
    private String password;       // password  (旧: pass)
    private String postalCode;     // postal_code (新規)
    private String address;        // address
    private String email;          // email     (旧: mail)
    private String phoneNumber;    // phone_number (旧: tel)
    private String cardNumber;     // card_number (旧: cardNum)
    private String cardName;       // card_name (新規)
    private String cardExpiration; // card_expiration (新規)

    // フルコンストラクタ
    public User(String userId, String userName, String password, String postalCode, String address, 
                   String email, String phoneNumber, String cardNumber, String cardName, String cardExpiration) {
        this.userId = userId;
        this.userName = userName;
        this.password = password;
        this.postalCode = postalCode;
        this.address = address;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.cardNumber = cardNumber;
        this.cardName = cardName;
        this.cardExpiration = cardExpiration;
    }

    // --- ゲッター (Getter) ---
    public String getUserId() { return userId; }
    public String getUserName() { return userName; }
    public String getPassword() { return password; }
    public String getPostalCode() { return postalCode; }
    public String getAddress() { return address; }
    public String getEmail() { return email; }
    public String getPhoneNumber() { return phoneNumber; }
    public String getCardNumber() { return cardNumber; }
    public String getCardName() { return cardName; }
    public String getCardExpiration() { return cardExpiration; }

    // --- セッター (Setter) 💡これが未定義だとサーブレットでエラーになります ---
    public void setUserId(String userId) { this.userId = userId; }
    public void setUserName(String userName) { this.userName = userName; }
    public void setPassword(String password) { this.password = password; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
    public void setAddress(String address) { this.address = address; }
    public void setEmail(String email) { this.email = email; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    // 💡 サーブレットでエラーが出ていた原因のメソッド群
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }
    public void setCardName(String cardName) { this.cardName = cardName; }
    public void setCardExpiration(String cardExpiration) { this.cardExpiration = cardExpiration; }
}