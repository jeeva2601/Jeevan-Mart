package com.jeevan.jeevanmart.listener;

import com.jeevan.jeevanmart.util.DatabaseMigrationRunner;
import com.jeevan.jeevanmart.util.DatabaseUtil;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.InputStream;
import java.util.Properties;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger logger =
            LoggerFactory.getLogger(AppContextListener.class);

    private HikariDataSource dataSource;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Initializing JeevanMart database connection...");

        try {
            Properties props = new Properties();

            try (InputStream in = getClass().getClassLoader()
                    .getResourceAsStream("config.properties")) {
                if (in != null) {
                    props.load(in);
                }
            }

            String jdbcUrl = env("JDBC_URL");

            if (jdbcUrl == null) {
                String host = env("MYSQLHOST");
                String port = env("MYSQLPORT");
                String database = env("MYSQLDATABASE");

                if (host != null && port != null && database != null) {
                    jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/"
                            + database
                            + "?useSSL=false&allowPublicKeyRetrieval=true"
                            + "&serverTimezone=UTC&characterEncoding=UTF-8";
                } else {
                    jdbcUrl = props.getProperty(
                            "db.url",
                            "jdbc:h2:mem:jeevanmart;DB_CLOSE_DELAY=-1;MODE=PostgreSQL"
                    );
                }
            }

            String jdbcUser = env("JDBC_USER");
            if (jdbcUser == null) {
                jdbcUser = env("MYSQLUSER");
            }
            if (jdbcUser == null) {
                jdbcUser = props.getProperty("db.user", "sa");
            }

            String jdbcPassword = System.getenv("JDBC_PASSWORD");
            if (jdbcPassword == null) {
                jdbcPassword = System.getenv("MYSQLPASSWORD");
            }
            if (jdbcPassword == null) {
                jdbcPassword = props.getProperty("db.password", "");
            }

            String driverClassName = env("JDBC_DRIVER");

            if (driverClassName == null) {
                if (jdbcUrl.startsWith("jdbc:mysql:")) {
                    driverClassName = "com.mysql.cj.jdbc.Driver";
                } else {
                    driverClassName = props.getProperty(
                            "db.driver", "org.h2.Driver"
                    );
                }
            }

            HikariConfig config = new HikariConfig();
            config.setDriverClassName(driverClassName);
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(jdbcUser);
            config.setPassword(jdbcPassword);
            config.setMaximumPoolSize(Integer.parseInt(
                    props.getProperty("db.pool.maxSize", "10")));
            config.setMinimumIdle(Integer.parseInt(
                    props.getProperty("db.pool.minIdle", "2")));
            config.setIdleTimeout(Long.parseLong(
                    props.getProperty("db.pool.idleTimeout", "300000")));
            config.setConnectionTimeout(Long.parseLong(
                    props.getProperty("db.pool.connectionTimeout", "20000")));
            config.setMaxLifetime(Long.parseLong(
                    props.getProperty("db.pool.maxLifetime", "1800000")));
            config.setPoolName("JeevanMartHikariPool");

            dataSource = new HikariDataSource(config);
            DatabaseUtil.setDataSource(dataSource);
            sce.getServletContext().setAttribute("dataSource", dataSource);

            logger.info("Database connection pool initialized. Driver: {}",
                    driverClassName);

            DatabaseMigrationRunner migrationRunner =
                    new DatabaseMigrationRunner(dataSource);
            migrationRunner.runMigrations();

        } catch (Exception e) {
            logger.error("Database initialization or migration failed", e);
            throw new RuntimeException(
                    "Application startup failed due to database error", e);
        }
    }

    private static String env(String name) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty()
                ? null : value.trim();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Closing JeevanMart database connection pool...");
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}