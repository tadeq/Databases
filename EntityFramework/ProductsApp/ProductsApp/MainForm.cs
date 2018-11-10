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
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void ProdList_Click(object sender, EventArgs e)
        {
            this.Hide();
            var newForm = new CategoryForm();
            newForm.FormClosed += (s, args) => this.Close();
            newForm.Show();
        }

        private void Order_Click(object sender, EventArgs e)
        {
            this.Hide();
            var newForm = new MakeOrder();
            newForm.FormClosed += (s, args) => this.Close();
            newForm.Show();
        }
    }
}
