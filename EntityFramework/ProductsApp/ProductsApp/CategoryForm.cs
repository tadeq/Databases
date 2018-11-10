using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProductsApp
{
    public partial class CategoryForm : Form
    {
        ProdContext db;
        public CategoryForm()
        {
            InitializeComponent();
        }

        private void CategoryForm_Load(object sender, EventArgs e)
        {
            CategoryDgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            ProductDgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            db = new ProdContext();
            db.Categories.Load();
            this.categoryBindingSource.DataSource = db.Categories.Local.ToBindingList();
            
        }

        private void Submit_Click(object sender, EventArgs e)
        {
            this.db.SaveChanges();
            this.CategoryDgv.Refresh();
        }

        private void CategoryDgv_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            db.Products.Load();
        }
    }
}
