import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.awt.*;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.imageio.ImageIO;
import Database.DbConnection;


@WebServlet("/Download_Certificate")
public class Download_Certificate extends HttpServlet {

    // ── Canvas dimensions ────────────────────────────────────────────────────
    private static final int W = 1400;
    private static final int H = 990;

    // ── Colour palette ───────────────────────────────────────────────────────
    private static final Color BG_OUTER   = new Color(15,  118, 110);   // teal-dark outer border fill
    private static final Color BG_INNER   = new Color(255, 255, 254);   // white card
    private static final Color GOLD       = new Color(180, 140, 30);    // solid gold
    private static final Color GOLD_LIGHT = new Color(212, 175, 55);    // bright gold
    private static final Color GOLD_PALE  = new Color(253, 246, 220);   // pale gold fill
    private static final Color TEAL       = new Color(13,  148, 136);   // primary teal
    private static final Color TEAL_DARK  = new Color(15,  118, 110);   // dark teal
    private static final Color TEAL_PALE  = new Color(240, 253, 251);   // pale teal fill
    private static final Color TEXT_DARK  = new Color(26,  26,  26);    // near-black
    private static final Color TEXT_MUTED = new Color(120, 113, 108);   // warm grey

    // ── Signature pen stroke colours ─────────────────────────────────────────
    private static final Color SIG_INK    = new Color(30,  60,  100);   // deep navy-blue ink

    // ════════════════════════════════════════════════════════════════════════
    //  SERVLET ENTRY POINT
    // ════════════════════════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentId = request.getParameter("student_id");
        String courseId  = request.getParameter("course_id");

        // ── Guard: missing params ────────────────────────────────────────────
        if (studentId == null || courseId == null
                || studentId.trim().isEmpty() || courseId.trim().isEmpty()) {
            sendErrorPage(response, "Invalid Access",
                "Missing student_id or course_id parameter.");
            return;
        }

        try {
            // ── DB fetch ─────────────────────────────────────────────────────
            DbConnection db = new DbConnection();
            Connection conn = db.getConnection();

          
            PreparedStatement ps = conn.prepareStatement(
                "SELECT sr.student_name, " +
                "       c.course_name, " +
                "       sc.date, " +
                "       COALESCE(tr.teacher_name, 'Course Director') AS teacher_name " +
                "FROM   student_register sr " +
                "JOIN   student_courses  sc ON sr.student_id = sc.student_id " +
                "JOIN   courses          c  ON sc.course_id  = c.course_id  " +
                "LEFT JOIN teacher_register tr ON c.teacher_id = tr.teacher_id " +
                "WHERE  sc.student_id   = ? " +
                "AND    sc.course_id    = ? " +
                "AND    sc.course_status = 'completed'"
            );
            ps.setString(1, studentId);
            ps.setString(2, courseId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                sendErrorPage(response, "Not Eligible",
                    "This course has not been completed yet, or the student record was not found.");
                rs.close(); ps.close(); conn.close();
                return;
            }

            String studentName = rs.getString("student_name");
            String courseName  = rs.getString("course_name");
            String teacherName = rs.getString("teacher_name");   // ← authorised signatory
            Date   issueDate   = rs.getDate("date");
            rs.close(); ps.close(); conn.close();

            // ── Generate image ────────────────────────────────────────────────
            BufferedImage cert = generateCertificate(
                studentName, courseName, teacherName, studentId, courseId, issueDate
            );

            // ── Stream as PNG download ────────────────────────────────────────
            String filename = "SkillSync_Certificate_"
                + studentName.replace(" ", "_") + ".png";
            response.setContentType("image/png");
            response.setHeader("Content-Disposition",
                "attachment; filename=\"" + filename + "\"");
            response.setHeader("Cache-Control", "no-cache");
            ImageIO.write(cert, "png", response.getOutputStream());
            response.getOutputStream().flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorPage(response, "Server Error",
                "Error generating certificate: " + e.getMessage());
        }
    }

    // ════════════════════════════════════════════════════════════════════════
    //  CORE GENERATION
    // ════════════════════════════════════════════════════════════════════════
    private BufferedImage generateCertificate(String studentName, String courseName,
                                               String teacherName,
                                               String studentId, String courseId,
                                               Date issueDate) {

        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = img.createGraphics();

        // Max quality rendering
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,      RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);
        g.setRenderingHint(RenderingHints.KEY_RENDERING,         RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION,     RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);

        // 1 ── Outer teal background ──────────────────────────────────────────
        g.setColor(BG_OUTER);
        g.fillRect(0, 0, W, H);

        // 2 ── Outer gold border lines ─────────────────────────────────────────
        drawOuterBorders(g);

        // 3 ── White inner card ────────────────────────────────────────────────
        int margin = 48;
        int innerX = margin, innerY = margin;
        int innerW = W - margin * 2, innerH = H - margin * 2;
        g.setColor(BG_INNER);
        g.fillRoundRect(innerX, innerY, innerW, innerH, 24, 24);

        // 4 ── Gold inner border ───────────────────────────────────────────────
        g.setColor(GOLD);
        g.setStroke(new BasicStroke(2.5f));
        g.drawRoundRect(innerX + 10, innerY + 10, innerW - 20, innerH - 20, 18, 18);

        // 5 ── Teal header band ────────────────────────────────────────────────
        int bandH = 130;
        g.setPaint(new GradientPaint(0, innerY, TEAL, 0, innerY + bandH, TEAL_DARK));
        g.fillRoundRect(innerX, innerY, innerW, bandH + 24, 24, 24);
        g.fillRect(innerX, innerY + bandH, innerW, 24);

        // 6 ── Brand name ──────────────────────────────────────────────────────
        g.setColor(Color.WHITE);
        Font brandFont = new Font("Serif", Font.BOLD | Font.ITALIC, 38);
        g.setFont(brandFont);
        String brand = "SkillSync";
        int brandX = (W - g.getFontMetrics().stringWidth(brand)) / 2;
        g.drawString(brand, brandX, innerY + 52);

        // 7 ── "CERTIFICATE OF COMPLETION" ─────────────────────────────────────
        g.setColor(new Color(255, 255, 255, 200));
        Font subtitleFont = new Font("SansSerif", Font.PLAIN, 13);
        g.setFont(subtitleFont);
        String subtitle = "C E R T I F I C A T E   O F   C O M P L E T I O N";
        int subX = (W - g.getFontMetrics().stringWidth(subtitle)) / 2;
        g.drawString(subtitle, subX, innerY + 80);

        // gold underline in header
        g.setColor(GOLD_LIGHT);
        g.setStroke(new BasicStroke(1.5f));
        g.drawLine(W/2 - 140, innerY + 92, W/2 + 140, innerY + 92);

        // 8 ── Decorative seal ─────────────────────────────────────────────────
        drawSeal(g, W / 2, innerY + bandH + 56);

        // 9 ── "This is to proudly certify that" ───────────────────────────────
        int contentTop = innerY + bandH + 140;
        g.setColor(TEXT_MUTED);
        g.setFont(new Font("SansSerif", Font.PLAIN, 17));
        String certifyText = "This is to proudly certify that";
        g.drawString(certifyText, (W - g.getFontMetrics().stringWidth(certifyText)) / 2, contentTop);

        // 10 ── Student name ───────────────────────────────────────────────────
        Font nameFont = new Font("Serif", Font.BOLD | Font.ITALIC, 68);
        g.setFont(nameFont);
        g.setColor(TEXT_DARK);
        while (g.getFontMetrics().stringWidth(studentName) > innerW - 120
               && nameFont.getSize() > 36) {
            nameFont = nameFont.deriveFont((float) nameFont.getSize() - 4);
            g.setFont(nameFont);
        }
        int nameX = (W - g.getFontMetrics().stringWidth(studentName)) / 2;
        int nameY = contentTop + 76;
        g.drawString(studentName, nameX, nameY);

        // 11 ── Gold underline below name ──────────────────────────────────────
        int lineHalfW = Math.min(g.getFontMetrics().stringWidth(studentName) / 2 + 30, 280);
        g.setColor(GOLD_LIGHT);
        g.setStroke(new BasicStroke(2f));
        g.drawLine(W/2 - lineHalfW, nameY + 8, W/2 + lineHalfW, nameY + 8);

        // 12 ── "has successfully completed" ───────────────────────────────────
        g.setColor(TEXT_MUTED);
        g.setFont(new Font("SansSerif", Font.PLAIN, 17));
        String completedText = "has successfully completed the course";
        g.drawString(completedText, (W - g.getFontMetrics().stringWidth(completedText)) / 2, nameY + 50);

        // 13 ── Course name ────────────────────────────────────────────────────
        Font courseFont = new Font("Serif", Font.BOLD, 46);
        g.setFont(courseFont);
        g.setColor(TEAL);
        while (g.getFontMetrics().stringWidth(courseName) > innerW - 100
               && courseFont.getSize() > 24) {
            courseFont = courseFont.deriveFont((float) courseFont.getSize() - 3);
            g.setFont(courseFont);
        }
        int courseX = (W - g.getFontMetrics().stringWidth(courseName)) / 2;
        int courseY = nameY + 110;
        g.drawString(courseName, courseX, courseY);

        // 14 ── Teal underline below course name ───────────────────────────────
        int cLineHalfW = Math.min(g.getFontMetrics().stringWidth(courseName) / 2 + 20, 250);
        g.setColor(TEAL);
        g.setStroke(new BasicStroke(2f));
        g.drawLine(W/2 - cLineHalfW, courseY + 6, W/2 + cLineHalfW, courseY + 6);

        // 15 ── Platform note ──────────────────────────────────────────────────
        g.setColor(TEXT_MUTED);
        g.setFont(new Font("SansSerif", Font.PLAIN, 15));
        String noteText = "on the SkillSync Online Learning Platform";
        g.drawString(noteText, (W - g.getFontMetrics().stringWidth(noteText)) / 2, courseY + 46);

        // 16 ── Gold ornamental divider ────────────────────────────────────────
        int divY = courseY + 90;
        drawGoldDivider(g, innerX + 60, divY, innerW - 120);

        // 17 ── Bottom section (date | cert ID | teacher signature) ─────────────
        int bottomY = divY + 56;
        drawBottomSection(g, studentId, courseId, teacherName, issueDate,
                          innerX, innerW, bottomY, innerY + innerH);

        // 18 ── Corner ornaments ───────────────────────────────────────────────
        drawCornerOrnaments(g, innerX + 18, innerY + 18, innerW - 36, innerH - 36);

        // 19 ── Diagonal watermark ─────────────────────────────────────────────
        drawWatermark(g);

        g.dispose();
        return img;
    }

    // ════════════════════════════════════════════════════════════════════════
    //  BOTTOM SECTION — Date  |  Certificate ID  |  Teacher Signature
    // ════════════════════════════════════════════════════════════════════════
    private void drawBottomSection(Graphics2D g,
                                   String studentId, String courseId,
                                   String teacherName,
                                   Date   issueDate,
                                   int innerX, int innerW,
                                   int y, int innerBottom) {

        DateTimeFormatter longFmt  = DateTimeFormatter.ofPattern("dd MMMM yyyy");
        DateTimeFormatter shortFmt = DateTimeFormatter.ofPattern("dd MMM yyyy");
        DateTimeFormatter idFmt    = DateTimeFormatter.ofPattern("yyyyMM");

        LocalDate ld       = issueDate.toLocalDate();
        String longDate    = ld.format(longFmt);
        String shortDate   = ld.format(shortFmt);
        String certId      = "SKS-" + studentId + "-" + courseId + "-" + ld.format(idFmt);

        int col1X = innerX + 90;          // Date column  (left)
        int col2X = W / 2;                // Cert ID column (centre)
        int col3X = innerX + innerW - 90; // Teacher signature (right)

        Font labelFont = new Font("SansSerif", Font.PLAIN, 12);
        Font sigScript = new Font("Serif",     Font.BOLD | Font.ITALIC, 30);

        // ── COL 1 : Issue Date ────────────────────────────────────────────────
        g.setFont(sigScript);
        g.setColor(SIG_INK);
        FontMetrics fm1 = g.getFontMetrics();
        g.drawString(shortDate, col1X - fm1.stringWidth(shortDate) / 2, y + 26);

        drawSignatureLine(g, col1X, y + 38, 180);

        g.setFont(labelFont);
        g.setColor(TEXT_MUTED);
        FontMetrics lfm1 = g.getFontMetrics();
        g.drawString("DATE OF ISSUE", col1X - lfm1.stringWidth("DATE OF ISSUE") / 2, y + 56);

        // ── COL 2 : Certificate ID Box ────────────────────────────────────────
        int boxW = 280, boxH = 60;
        int boxX = col2X - boxW / 2;
        int boxY = y + 4;

        // teal filled rounded rectangle
        g.setColor(TEAL_PALE);
        g.fillRoundRect(boxX, boxY, boxW, boxH, 12, 12);
        g.setColor(TEAL);
        g.setStroke(new BasicStroke(1.5f));
        g.drawRoundRect(boxX, boxY, boxW, boxH, 12, 12);

        // cert ID text (monospaced)
        g.setFont(new Font("Monospaced", Font.BOLD, 14));
        g.setColor(TEAL_DARK);
        FontMetrics idFm = g.getFontMetrics();
        g.drawString(certId, col2X - idFm.stringWidth(certId) / 2, boxY + 26);

        // label inside box
        g.setFont(new Font("SansSerif", Font.PLAIN, 11));
        g.setColor(TEXT_MUTED);
        FontMetrics idLblFm = g.getFontMetrics();
        g.drawString("CERTIFICATE ID", col2X - idLblFm.stringWidth("CERTIFICATE ID") / 2, boxY + 46);

        // ── COL 3 : Teacher Signature ─────────────────────────────────────────
        drawTeacherSignature(g, col3X, y, teacherName);

        // ── Footer strip ──────────────────────────────────────────────────────
        g.setFont(new Font("SansSerif", Font.PLAIN, 11));
        g.setColor(TEXT_MUTED);
        String footer = "This certificate is issued by SkillSync Learning Management Platform  ·  " + longDate;
        FontMetrics footFm = g.getFontMetrics();
        g.drawString(footer, (W - footFm.stringWidth(footer)) / 2, innerBottom - 18);
    }

    // ════════════════════════════════════════════════════════════════════════
    //  TEACHER SIGNATURE BLOCK  (right column)
    //  Renders: cursive-style name + "Course Instructor" + gold line
    // ════════════════════════════════════════════════════════════════════════
    private void drawTeacherSignature(Graphics2D g, int cx, int y, String teacherName) {

        // ── Hand-drawn swirl above the name (decorative) ──────────────────────
        drawSignatureSwirl(g, cx, y - 4, teacherName);

        // ── Teacher name in signature script ──────────────────────────────────
        Font sigFont = new Font("Serif", Font.BOLD | Font.ITALIC, 32);
        g.setFont(sigFont);
        g.setColor(SIG_INK);
        FontMetrics sfm = g.getFontMetrics();

        // Shrink if name is very long
        while (sfm.stringWidth(teacherName) > 230 && sigFont.getSize() > 18) {
            sigFont = sigFont.deriveFont((float) sigFont.getSize() - 2);
            g.setFont(sigFont);
            sfm = g.getFontMetrics();
        }
        int nameX = cx - sfm.stringWidth(teacherName) / 2;
        g.drawString(teacherName, nameX, y + 26);

        // ── Gold horizontal line below signature ──────────────────────────────
        drawSignatureLine(g, cx, y + 38, 180);

        // ── "Course Instructor" label ──────────────────────────────────────────
        Font labelFont = new Font("SansSerif", Font.PLAIN, 12);
        g.setFont(labelFont);
        g.setColor(TEXT_MUTED);
        FontMetrics lfm = g.getFontMetrics();
        g.drawString("COURSE INSTRUCTOR", cx - lfm.stringWidth("COURSE INSTRUCTOR") / 2, y + 56);

        // ── "AUTHORISED SIGNATORY" sub-label ─────────────────────────────────
        g.setFont(new Font("SansSerif", Font.PLAIN, 10));
        g.setColor(new Color(160, 155, 150));
        FontMetrics slfm = g.getFontMetrics();
        g.drawString("AUTHORISED SIGNATORY",
                     cx - slfm.stringWidth("AUTHORISED SIGNATORY") / 2, y + 70);
    }

    /**
     * Draws a simple decorative pen-stroke swirl above the signature name.
     * Uses Bezier curves to simulate a hand-written flourish.
     */
    private void drawSignatureSwirl(Graphics2D g, int cx, int topY, String teacherName) {
        Graphics2D sg = (Graphics2D) g.create();
        sg.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        sg.setColor(new Color(SIG_INK.getRed(), SIG_INK.getGreen(), SIG_INK.getBlue(), 180));
        sg.setStroke(new BasicStroke(1.6f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));

        // Derive a width based on the teacher's name length (so it feels proportional)
        Font tmpFont = new Font("Serif", Font.BOLD | Font.ITALIC, 32);
        sg.setFont(tmpFont);
        int nameW = Math.min(sg.getFontMetrics().stringWidth(teacherName), 230);
        int hw    = nameW / 2 + 10; // half-width of flourish

        // Left flourish curve
        GeneralPath left = new GeneralPath();
        left.moveTo(cx - hw, topY - 6);
        left.curveTo(cx - hw + 18, topY - 18, cx - 30, topY - 20, cx, topY - 14);
        sg.draw(left);

        // Right flourish curve (mirror)
        GeneralPath right = new GeneralPath();
        right.moveTo(cx + hw, topY - 6);
        right.curveTo(cx + hw - 18, topY - 18, cx + 30, topY - 20, cx, topY - 14);
        sg.draw(right);

        // Small horizontal underline of the flourish
        sg.setStroke(new BasicStroke(1f));
        sg.setColor(new Color(GOLD_LIGHT.getRed(), GOLD_LIGHT.getGreen(), GOLD_LIGHT.getBlue(), 140));
        sg.drawLine(cx - hw, topY - 6, cx + hw, topY - 6);

        sg.dispose();
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — Gold signature underline
    // ════════════════════════════════════════════════════════════════════════
    private void drawSignatureLine(Graphics2D g, int cx, int y, int lineW) {
        g.setColor(GOLD);
        g.setStroke(new BasicStroke(1.5f));
        g.drawLine(cx - lineW / 2, y, cx + lineW / 2, y);
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — Outer border decoration
    // ════════════════════════════════════════════════════════════════════════
    private void drawOuterBorders(Graphics2D g) {
        g.setColor(GOLD);
        g.setStroke(new BasicStroke(3f));
        g.drawRoundRect(12, 12, W - 24, H - 24, 16, 16);
        g.setColor(new Color(212, 175, 55, 120));
        g.setStroke(new BasicStroke(1.5f));
        g.drawRoundRect(20, 20, W - 40, H - 40, 12, 12);
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — Gold medal seal
    // ════════════════════════════════════════════════════════════════════════
    private void drawSeal(Graphics2D g, int cx, int cy) {
        g.setColor(GOLD_LIGHT);
        drawStar(g, cx, cy, 38, 50, 16);
        g.setColor(GOLD);
        g.fillOval(cx - 30, cy - 30, 60, 60);
        g.setColor(Color.WHITE);
        g.fillOval(cx - 22, cy - 22, 44, 44);
        g.setColor(TEAL);
        g.setStroke(new BasicStroke(4f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        int[] px = { cx - 10, cx - 2, cx + 12 };
        int[] py = { cy + 2,  cy + 10, cy - 8  };
        g.drawPolyline(px, py, 3);
    }

    private void drawStar(Graphics2D g, int cx, int cy, int innerR, int outerR, int points) {
        double step = Math.PI / points;
        int[] xs = new int[points * 2];
        int[] ys = new int[points * 2];
        for (int i = 0; i < points * 2; i++) {
            double angle = i * step - Math.PI / 2;
            double r = (i % 2 == 0) ? outerR : innerR;
            xs[i] = (int)(cx + r * Math.cos(angle));
            ys[i] = (int)(cy + r * Math.sin(angle));
        }
        g.fillPolygon(xs, ys, points * 2);
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — Gold ornamental centre divider
    // ════════════════════════════════════════════════════════════════════════
    private void drawGoldDivider(Graphics2D g, int x, int y, int w) {
        g.setPaint(new GradientPaint(x, y, new Color(212,175,55,0), x+w/2-50, y, GOLD_LIGHT));
        g.setStroke(new BasicStroke(1.5f));
        g.drawLine(x, y, x+w/2-50, y);

        g.setColor(GOLD_LIGHT);
        int[] dx = { x+w/2, x+w/2+8, x+w/2, x+w/2-8 };
        int[] dy = { y-6,   y,        y+6,   y        };
        g.fillPolygon(dx, dy, 4);
        g.fillOval(x+w/2-28, y-3, 6, 6);
        g.fillOval(x+w/2+22, y-3, 6, 6);

        g.setPaint(new GradientPaint(x+w/2+50, y, GOLD_LIGHT, x+w, y, new Color(212,175,55,0)));
        g.drawLine(x+w/2+50, y, x+w, y);
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — Corner ornaments
    // ════════════════════════════════════════════════════════════════════════
    private void drawCornerOrnaments(Graphics2D g, int x, int y, int w, int h) {
        g.setColor(GOLD_LIGHT);
        g.setStroke(new BasicStroke(2f));
        int len = 28;
        // TL
        g.drawLine(x, y, x+len, y); g.drawLine(x, y, x, y+len); g.fillOval(x-4, y-4, 8, 8);
        // TR
        g.drawLine(x+w-len, y, x+w, y); g.drawLine(x+w, y, x+w, y+len); g.fillOval(x+w-4, y-4, 8, 8);
        // BL
        g.drawLine(x, y+h-len, x, y+h); g.drawLine(x, y+h, x+len, y+h); g.fillOval(x-4, y+h-4, 8, 8);
        // BR
        g.drawLine(x+w, y+h-len, x+w, y+h); g.drawLine(x+w-len, y+h, x+w, y+h); g.fillOval(x+w-4, y+h-4, 8, 8);
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — Diagonal watermark
    // ════════════════════════════════════════════════════════════════════════
    private void drawWatermark(Graphics2D g) {
        Graphics2D wg = (Graphics2D) g.create();
        wg.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        wg.setColor(new Color(13, 148, 136, 10));
        Font wFont = new Font("Serif", Font.BOLD, 90);
        wg.setFont(wFont);
        wg.rotate(Math.toRadians(-30), W / 2.0, H / 2.0);
        String wText = "SKILLSYNC";
        wg.drawString(wText, (W - wg.getFontMetrics().stringWidth(wText)) / 2, H / 2 + 30);
        wg.dispose();
    }

    // ════════════════════════════════════════════════════════════════════════
    //  HELPER — HTML error page
    // ════════════════════════════════════════════════════════════════════════
    private void sendErrorPage(HttpServletResponse response, String title, String message)
            throws IOException {
        response.setContentType("text/html; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html><html><head><meta charset='UTF-8'>");
        out.println("<title>Certificate Error – SkillSync</title><style>");
        out.println("body{font-family:'Segoe UI',sans-serif;background:#f0fdfb;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0;}");
        out.println(".card{background:#fff;border:1px solid #e2e8e4;border-radius:20px;padding:48px 40px;max-width:460px;text-align:center;box-shadow:0 12px 40px rgba(0,0,0,.10);}");
        out.println(".icon{font-size:3rem;margin-bottom:16px;}h2{color:#1a1a1a;font-size:1.5rem;margin-bottom:10px;}");
        out.println("p{color:#78716c;font-size:.95rem;line-height:1.65;margin-bottom:24px;}");
        out.println("a{display:inline-block;background:#0d9488;color:#fff;padding:11px 28px;border-radius:100px;font-weight:600;text-decoration:none;}");
        out.println("a:hover{background:#0f766e;}</style></head><body><div class='card'>");
        out.println("<div class='icon'>⚠️</div><h2>" + escapeHtml(title) + "</h2>");
        out.println("<p>" + escapeHtml(message) + "</p>");
        out.println("<a href='javascript:history.back()'>← Go Back</a></div></body></html>");
        out.close();
    }

    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
}
