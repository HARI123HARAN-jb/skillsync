/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author user
 */
import java.io.*;
import javax.servlet.ServletContext;
import org.json.*;
import java.util.*;

public class ChatBotService {
    public static String getReply(String userMsg, ServletContext context) {

        userMsg = userMsg.toLowerCase();

        try {
            InputStream is = context.getResourceAsStream("/WEB-INF/chatbot.json");
            BufferedReader br = new BufferedReader(new InputStreamReader(is));

            StringBuilder jsonText = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                jsonText.append(line);
            }

            JSONArray data = new JSONArray(jsonText.toString());

            for (int i = 0; i < data.length(); i++) {
                JSONObject obj = data.getJSONObject(i);
                JSONArray keywords = obj.getJSONArray("keywords");

                int matchCount = 0;
                for (int k = 0; k < keywords.length(); k++) {
                    if (userMsg.contains(keywords.getString(k))) {
                        matchCount++;
                    }
                }

                if (matchCount > 0) {
                    return obj.getString("answer");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "I’m unable to answer that right now. Please try asking something different.";
    }
}
