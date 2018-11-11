using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProductsApp
{
    public partial class MakeOrder : Form
    {
        ProdContext db;
        DataTable toOrder = new DataTable();
        public MakeOrder()
        {
            db = new ProdContext();
            InitializeComponent();
            SelectedDgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
        }

        private void MakeOrder_Load(object sender, EventArgs e)
        {
            db.Products.Load();
            this.productsBindingSource.DataSource = db.Products.Local.ToBindingList();
            toOrder.Columns.Add("ProductID", typeof(int));
            toOrder.Columns.Add("ProductName", typeof(string));
            toOrder.Columns.Add("Quantity", typeof(int));
        }

        private void ProductsDgv_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridViewRow row = ProductsDgv.Rows[e.RowIndex];
            IDTextBox.Text = row.Cells[0].Value.ToString();
            NameTextBox.Text = row.Cells[1].Value.ToString();
            QuantityTextBox.Text = "0";
        }

        private void AddButton_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(QuantityTextBox.Text.ToString()) > 0)
            {
                toOrder.Rows.Add(Convert.ToInt32(IDTextBox.Text.ToString()), NameTextBox.Text.ToString(), Convert.ToInt32(QuantityTextBox.Text.ToString()));
                SelectedDgv.DataSource = toOrder;
            }
        }

        private void OrderButton_Click(object sender, EventArgs e)
        {
            var CID = Convert.ToInt32(CustomerIDTextBox.Text.ToString());
            var newOrder = new Order { CustomerID = CID };
            var details = new List<OrderDetails>();
            for (int i = 0; i < SelectedDgv.Rows.Count; i++)
            {
                details.Add(new OrderDetails{OrderID = newOrder.OrderID, ProductID = Convert.ToInt32(SelectedDgv.Rows[i].Cells[0].Value.ToString()), 
                    Quantity = Convert.ToInt32(SelectedDgv.Rows[i].Cells[2].Value.ToString())});
            }
            newOrder.Details = details;
            db.Orders.Add(newOrder);
            db.SaveChanges();
            Close();
        }
    }
}
