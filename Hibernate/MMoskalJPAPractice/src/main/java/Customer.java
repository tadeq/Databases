import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.Set;

@Entity
public class Customer extends Company{
    @OneToMany(mappedBy = "customer")
    private Set<Invoice> invoices;
    private Double discount;
}
