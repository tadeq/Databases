import javax.persistence.*;
import java.util.LinkedList;
import java.util.List;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer categoryID;
    private String name;
    @OneToMany(mappedBy = "category")
    private List<Product> products;

    public Category() {
    }

    public Category(String name) {
        this.name = name;
        products = new LinkedList<>();
    }

    public void addProduct(Product p) {
        this.products.add(p);
        p.setCategory(this);
    }

    public List<Product> getProducts() {
        return this.products;
    }
}
