import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Product {
    @Id
    private String productName;
    private Integer unitsInStock;
    @ManyToOne
    @JoinColumn(name = "SUPPLIER_FK")
    private Supplier supplier;
    @ManyToOne
    @JoinColumn(name = "CATEGORY_FK")
    private Category category;
    @ManyToMany(cascade = CascadeType.PERSIST)
    private Set<Invoice> invoices;

    public Product() {
    }

    public Product(String name) {
        this.productName = name;
        invoices = new HashSet<>();
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
        supplier.addProduct(this);
    }

    public void setCategory(Category category) {
        this.category = category;
        category.addProduct(this);
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public Category getCategory() {
        return category;
    }

    public Set<Invoice> getInvoices() {
        return invoices;
    }

    public void addInvoice(Invoice invoice){
        this.invoices.add(invoice);
        invoice.getProducts().add(this);
    }
}
