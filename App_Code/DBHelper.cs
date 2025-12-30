using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// 数据库帮助类
/// </summary>
public class DBHelper
{
    private static string connectionString = ConfigurationManager.ConnectionStrings["OnlineShopDB"].ConnectionString;

    /// <summary>
    /// 执行查询，返回DataTable
    /// </summary>
    public static DataTable ExecuteQuery(string sql, params MySqlParameter[] parameters)
    {
        DataTable dt = new DataTable();
        try
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception("查询数据失败: " + ex.Message);
        }
        return dt;
    }

    /// <summary>
    /// 执行增删改，返回受影响行数
    /// </summary>
    public static int ExecuteNonQuery(string sql, params MySqlParameter[] parameters)
    {
        try
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception("执行操作失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 执行查询，返回单个值
    /// </summary>
    public static object ExecuteScalar(string sql, params MySqlParameter[] parameters)
    {
        try
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception("查询数据失败: " + ex.Message);
        }
    }

    /// <summary>
    /// 测试数据库连接
    /// </summary>
    public static bool TestConnection()
    {
        try
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                return true;
            }
        }
        catch
        {
            return false;
        }
    }
}
