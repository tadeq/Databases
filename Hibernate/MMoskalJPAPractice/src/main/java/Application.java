import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;


public class Application {
    private static SessionFactory sessionFactory = null;

    public static void main(String[] args) {
        sessionFactory = getSessionFactory();
        Session session = sessionFactory.openSession();
        Transaction tx = session.beginTransaction();
        Supplier supplier = new Supplier("Supplier");
        Category category = new Category("Category");
        for (int i=0;i<5;i++){
            Product product = new Product("Product"+i);
            product.setSupplier(supplier);
            product.setCategory(category);
            session.save(product);
        }
        session.save(supplier);
        for (Product p : category.getProducts()){
            System.out.println(p.getCategory());
        }
        System.out.println(category.getProducts());
        session.save(category);
        Product foundProduct = session.get(Product.class,"Product1");
        Invoice invoice = new Invoice(10);
        foundProduct.addInvoice(invoice);
        session.save(invoice);
        tx.commit();
        session.close();
        sessionFactory.close();
    }

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration configuration = new Configuration();
            sessionFactory = configuration.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}
