import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Company {
    @Id
    protected String companyName;
    @Embedded
    private Address address;
}
