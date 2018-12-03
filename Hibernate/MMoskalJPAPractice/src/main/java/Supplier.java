import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier extends Company {
    @OneToMany(mappedBy = "supplier")
    private Set<Product> products;
    private String bankAccountNumber;

    public Supplier() {
    }

    public Supplier(String name) {
        super(name);
        this.products = new HashSet<>();
    }

    public void addProduct(Product p) {
        products.add(p);
    }

    public Set<Product> getProducts() {
        return this.products;
    }

    public void setBankAccountNumber(String bankAccountNumber) {
        this.bankAccountNumber = bankAccountNumber;
    }
}
