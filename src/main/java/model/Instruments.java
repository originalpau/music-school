package model;

public class Instruments {
    private String id;
    private String kind;
    private String brand;
    private int price;
    private boolean isAvailable;

    public Instruments(String id, String kind, String brand, int price, boolean isAvailable) {
        this.id = id;
        this.kind = kind;
        this.brand = brand;
        this.price = price;
        this.isAvailable = isAvailable;
    }

    public String getID() {
        return id;
    }

    public String getKind() {
        return kind;
    }

    public String getBrand() {
        return brand;
    }

    public int getPrice() {
        return price;
    }

    public boolean getStatus() {
        return isAvailable;
    }

    //does not return kind
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Instrument: [ID: " + id);
        sb.append(", brand: " + brand + ", price: " + price + "]");
        return sb.toString();
    }
}
