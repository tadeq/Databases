using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProductsApp
{
    public partial class AddProductForm : Form
    {
        ProdContext db;
        public AddProductForm()
        {
            db = new ProdContext();
            InitializeComponent();
        }

        private void SubmitButton_Click(object sender, EventArgs e)
        {
            var newProduct = new Product
            {
                Name = NameTextBox.Text.ToString(),
                UnitsInStock = Convert.ToInt32(UnitsTextBox.Text.ToString()),
                CategoryID = Convert.ToInt32(CategoryTextBox.Text.ToString()),
                UnitPrice = Convert.ToDecimal(PriceTextBox.Text.ToString())
            };
            db.Products.Add(newProduct);
            db.SaveChanges();
            Close();
        }
    }
}
