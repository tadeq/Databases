import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Customer extends Company {
    @OneToMany(mappedBy = "customer")
    private Set<Invoice> invoices;
    private Double discount;

    public Customer() {
    }

    public Customer(String name) {
        super(name);
        invoices = new HashSet<>();
    }

    public void addInvoice(Invoice i) {
        this.invoices.add(i);
        i.setCustomer(this);
    }

    public Set<Invoice> getInvoices() {
        return this.invoices;
    }
}
