import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer invoiceNumber;
    private Integer quantity;
    @ManyToOne
    @JoinColumn(name = "CUSTOMER_FK")
    private Customer customer;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private Set<Product> products;

    public Invoice() {
    }

    public Invoice(int quantity) {
        this.quantity = quantity;
        this.products = new HashSet<>();
    }

    public Invoice(Integer quantity, Customer customer, Set<Product> products) {
        this.quantity = quantity;
        this.customer = customer;
        this.products = products;
    }

    public void addProduct(Product p) {
        this.products.add(p);
        p.getInvoices().add(this);
    }

    public Set<Product> getProducts() {
        return products;
    }

    public void setCustomer(Customer c) {
        this.customer = c;
        c.getInvoices().add(this);
    }
}
