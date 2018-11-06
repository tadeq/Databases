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
        static void Main(string[] args)
        {
            using (var db = new ProdContext())
            {
                Console.WriteLine("Podaj nazwe kategorii");
                var CategoryName = Console.ReadLine();
                var category = new Category { Name = CategoryName };
                db.Categories.Add(category);
                db.SaveChanges();
                Application.Run(new CategoryForm());
            }
        }
    }
}
