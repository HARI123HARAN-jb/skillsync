package Database;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * 🍃 MongoConnection - The new core for Skillsync using MongoDB Atlas.
 */
public class MongoConnection {

    private static MongoClient mongoClient = null;
    private static MongoDatabase database = null;
    private static Map<String, String> env = new HashMap<>();

    static {
        loadEnv();
        String uri = getEnv("MONGO_URI");
        String dbName = getEnv("DATABASE_NAME", "defaultdb");

        if (uri != null) {
            try {
                mongoClient = MongoClients.create(uri);
                database = mongoClient.getDatabase(dbName);
                System.out.println("✅ MongoDB Connected Successfully!");
            } catch (Exception e) {
                System.err.println("❌ MongoDB Connection Failed: " + e.getMessage());
            }
        } else {
            System.err.println("❌ MONGO_URI not found in .env or System Environment!");
        }
    }

    private static void loadEnv() {
        try (BufferedReader br = new BufferedReader(new FileReader(".env"))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split("=", 2);
                if (parts.length == 2) {
                    env.put(parts[0].trim(), parts[1].trim());
                }
            }
        } catch (Exception e) {
            // .env not found, will rely on System environment variables
            System.out.println("ℹ️ .env file not found, using System Environment Variables.");
        }
    }

    private static String getEnv(String key) {
        return getEnv(key, null);
    }

    private static String getEnv(String key, String defaultValue) {
        String value = env.get(key);
        if (value == null) {
            value = System.getenv(key);
        }
        return (value != null) ? value : defaultValue;
    }

    public static MongoDatabase getDatabase() {
        return database;
    }

    public static void close() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("💤 MongoDB Connection Closed.");
        }
    }
}
