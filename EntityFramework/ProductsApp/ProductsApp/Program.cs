using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProductsApp
{
    class Program
    {
        static void PrintCategoriesNames(ProdContext db)
        {
            var categoriesNamesQuery = db.Categories;
            foreach (Category cat in categoriesNamesQuery)
            {
                Console.WriteLine(cat.Name);
            }
        }

        static void PrintCategoriesNames_Immediate(ProdContext db)
        {
            var categoriesNamesQuery = db.Categories.ToList();
            foreach (Category cat in categoriesNamesQuery)
            {
                Console.WriteLine(cat.Name);
            }
        }

        static void PrintCategoriesProducts_Query_Joins(ProdContext db)
        {
            var query = from category in db.Categories
                        join product in db.Products on category.CategoryID equals product.CategoryID
                        select new
                        {
                            CategoryID = category.CategoryID,
                            CategoryName = category.Name,
                            ProductID = product.ProductID,
                            ProductName = product.Name
                        };
            foreach(var cp in query)
            {
                Console.WriteLine("{0}\t{1}\t{2}\t{3}", cp.CategoryID, cp.CategoryName, cp.ProductID, cp.ProductName);
            }
        }

        static void PrintCategoriesProducts_Method_Joins(ProdContext db)
        {
            var query = db.Categories.Join(db.Products, category => category.CategoryID, product => product.CategoryID,
                (category, product) => new
                {
                    CategoryID = category.CategoryID,
                    CategoryName = category.Name,
                    ProductID = product.ProductID,
                    ProductName = product.Name
                });
            foreach (var cp in query)
            {
                Console.WriteLine("{0}\t{1}\t{2}\t{3}", cp.CategoryID, cp.CategoryName, cp.ProductID, cp.ProductName);
            }
        }

        static void PrintCategoriesProducts_Query_NavigationProperties(ProdContext db)
        {
            var query = from category in db.Categories select new
            {
                Category = category,
                Products = category.Products
            };
            foreach(var cat in query)
            {
                if (cat.Products != null)
                {
                    foreach (Product prod in cat.Products)
                    {
                        Console.WriteLine("{0}\t{1}\t{2}\t{3}", cat.Category.CategoryID, cat.Category.Name, prod.ProductID, prod.Name);
                    }
                }
            }
        }

        static void PrintCategoriesProducts_Query_EagerLoading(ProdContext db)
        {
            var query = from category in db.Categories.Include("Categories")
                        select new
                        {
                            Category = category,
                            Products = category.Products
                        };
            foreach (var cat in query)
            {
                if (cat.Products != null)
                {
                    foreach (Product prod in cat.Products)
                    {
                        Console.WriteLine("{0}\t{1}\t{2}\t{3}", cat.Category.CategoryID, cat.Category.Name, prod.ProductID, prod.Name);
                    }
                }
            }
        }

        static void PrintProductsSum_Query(ProdContext db)
        {
            var query = from category in db.Categories
                        join product in db.Products on category.CategoryID equals product.CategoryID into catProd
                        from cp in catProd.DefaultIfEmpty()
                        group cp by category.Name into grouped
                        select new
                        {
                            CategoryName = grouped.Key,
                            TotalProducts = grouped.Count(elem => elem.ProductID != null)
                        };
            foreach (var cat in query)
            {
                Console.WriteLine("{0}\t{1}", cat.CategoryName, cat.TotalProducts);
            }
        }

        static void PrintProductsSum_Method(ProdContext db)
        {
            var query = db.Categories.GroupJoin(db.Products, category => category.CategoryID, product => product.CategoryID,
                (category, product) => new
                {
                    Category = category,
                    Product = product
                }).SelectMany(cp => cp.Product.DefaultIfEmpty(), (cat, prod) => new
                {
                    Name = cat.Category.Name,
                    TotalProducts = cat.Product.Count()
                });
            foreach (var cat in query)
            {
                Console.WriteLine("{0}\t{1}", cat.Name, cat.TotalProducts);
            }
        }

        static void Main(string[] args)
        {
            using (var db = new ProdContext())
            {
                Application.Run(new MainForm());
            }
        }
    }
}
