using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace databaseProjectCRUD
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            groupBox1.Visible = false;
            dataGridView1.Visible = false;
            button5.Visible = false;
        }
        private string conString = "Data Source=MICHAEL-STRIX\\SQLEXPRESS;Initial Catalog=TEST;Integrated Security=True";

        private int trybOperacji=-1;
        private int idKlienta;
        private int idPracownika;
        private int selected = -1;
        private void pobierzDane()
        {
            dataGridView1.Columns.Clear();
            DataTable dtemployees = new DataTable();
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand("exec showTransaction;", con))
                {
                    con.Open();
                    if (con.State == ConnectionState.Open)
                    {
                        SqlDataReader reader = cmd.ExecuteReader();
                        dtemployees.Load(reader);
                        dataGridView1.DataSource = dtemployees;
                    }
                }
            }
        }

        private void pokazTabele()
        {
            dataGridView1.AllowUserToAddRows = false;
            dataGridView1.AllowUserToDeleteRows = true;
            dataGridView1.Columns.Clear();
            //Creating FIRST ROWS IN DATA TABLE
            dataGridView1.Visible = true;

        }
        private void button2_Click(object sender, EventArgs e)
        {
            button5.Visible = true;
            trybOperacji = 1;
            pokazTabele();
            pobierzDane();
            if (groupBox1.Visible == false)
            {
                groupBox1.Visible = true;
            }
            

        }

        private void button3_Click(object sender, EventArgs e)
        {
            button5.Visible = true;
            trybOperacji = 2;
            pokazTabele();
            pobierzDane();
            if (groupBox1.Visible == false)
            {
                groupBox1.Visible = true;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            button5.Visible = true;
            if (groupBox1.Visible == true)
            {
                groupBox1.Visible = false;
            }
            trybOperacji = 3;
            pokazTabele();
            pobierzDane();
           
        }

        private void button1_Click(object sender, EventArgs e)
        {
            pokazTabele();
            pobierzDane();
            button5.Visible = false;
        }

        private bool sprawdzPolaFormularza()
        {
            if ((textBox1.TextLength == 0)||(int.TryParse(textBox1.Text,out idKlienta) == false)){
                MessageBox.Show("ID Klienta nie moze pozostac puste i musi byc INTem");
                return false;
            }
            else
            {
                if((textBox2.TextLength == 0) || (int.TryParse(textBox2.Text, out idPracownika) == false)){
                    MessageBox.Show("ID Klienta nie moze pozostac puste i musi byc INTem");
                    return false;
                }
                else
                {
                    return true;
                }
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (trybOperacji == -1)
            {
                MessageBox.Show("Najpierw wybierz rodzaj operacji z gornego panelu przyciskow");
                button5.Visible = false;
            }
            else
            {
                switch (trybOperacji)
                {
                    case 1: //INSERT
                        {
                            if (sprawdzPolaFormularza())
                            {
                                using (SqlConnection con = new SqlConnection(conString))
                                {
                                    using (SqlCommand cmd = new SqlCommand())
                                    {
                                        con.Open();
                                        cmd.Connection = con;
                                        cmd.CommandText = "exec makeTransaction @ID_KL, @ID_PR, @Data1, @Data2, @WAY, @TRANS";

                                        cmd.Parameters.AddWithValue("@ID_KL", idKlienta);
                                        cmd.Parameters.AddWithValue("@ID_PR", idPracownika);
                                        cmd.Parameters.AddWithValue("@Data1", textBox3.Text);
                                        cmd.Parameters.AddWithValue("@Data2", textBox4.Text);
                                        cmd.Parameters.AddWithValue("@WAY", textBox5.Text);
                                        cmd.Parameters.AddWithValue("@TRANS", textBox6.Text);

                                        cmd.ExecuteReader();
                                       
                                        con.Close();
                                        
                                    }
                                }
                                pobierzDane();
                            }
                        }break;
                    case 2: //UPDATE
                        {
                            
                            for (int i = 0; i < dataGridView1.Rows.Count; i++)
                            {
                                if (dataGridView1[0, i].Selected == true)
                                {
                                    selected = int.Parse(dataGridView1[0,i].Value.ToString());
                                }
                            }
                            if (selected == -1)
                            {
                                MessageBox.Show("Wybierz rekord, ktory chcesz zmodyfikować wybierajac odpowiedni WIERSZ w kolumnie NR_TRANSAKCJI");
                            }
                            else
                            {
                                if (sprawdzPolaFormularza())
                                {
                                    using (SqlConnection con = new SqlConnection(conString))
                                    {
                                        using (SqlCommand cmd = new SqlCommand())
                                        {
                                            con.Open();
                                            cmd.Connection = con;
                                            cmd.CommandText = "exec updateTransaction @ID_KL, @ID_PR, @Data1, @Data2, @WAY, @TRANS, @UPID";

                                            cmd.Parameters.AddWithValue("@ID_KL", idKlienta);
                                            cmd.Parameters.AddWithValue("@ID_PR", idPracownika);
                                            cmd.Parameters.AddWithValue("@Data1", textBox3.Text);
                                            cmd.Parameters.AddWithValue("@Data2", textBox4.Text);
                                            cmd.Parameters.AddWithValue("@WAY", textBox5.Text);
                                            cmd.Parameters.AddWithValue("@TRANS", textBox6.Text);
                                            cmd.Parameters.AddWithValue("@UPID", selected);
                                            cmd.ExecuteReader();

                                            con.Close();

                                        }
                                    }
                                    pobierzDane();
                                }
                            }



                        }
                        break;
                    case 3:
                        {
                            for (int i = 0; i < dataGridView1.Rows.Count; i++)
                            {
                                if (dataGridView1[0, i].Selected == true)
                                {
                                    selected = int.Parse(dataGridView1[0, i].Value.ToString());
                                }
                            }
                            if (selected == -1)
                            {
                                MessageBox.Show("Wybierz rekord, ktory chcesz usunac wybierajac odpowiedni WIERSZ w kolumnie NR_TRANSAKCJI");
                            }
                            else
                            {
                               
                                    using (SqlConnection con = new SqlConnection(conString))
                                    {
                                        using (SqlCommand cmd = new SqlCommand())
                                        {
                                            con.Open();
                                            cmd.Connection = con;
                                            cmd.CommandText = "exec deleteTransaction @ID";

                                            cmd.Parameters.AddWithValue("@ID", selected);

                                            cmd.ExecuteReader();

                                            con.Close();

                                        }
                                    }
                                    pobierzDane();
                                
                            }
                            
                        }
                        break;

                }
            }
            
        }
    }
}
