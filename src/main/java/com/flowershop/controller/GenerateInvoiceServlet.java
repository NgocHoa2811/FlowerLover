package com.flowershop.controller;

import com.itextpdf.layout.Document;
import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.property.TextAlignment;
import com.itextpdf.layout.property.UnitValue;

import org.bson.types.ObjectId;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/generate-invoice")
public class GenerateInvoiceServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderId = request.getParameter("orderId");

        if (orderId == null || orderId.length() != 24) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu hoặc sai định dạng orderId");
            return;
        }

        MongoDatabase db = mongoClient.getDatabase("flowerlover");
        MongoCollection<org.bson.Document> orders = db.getCollection("orders");
        org.bson.Document order = orders.find(Filters.eq("_id", new ObjectId(orderId))).first();

        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=invoice_" + orderId + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdf = new PdfDocument(writer);
            Document doc = new Document(pdf);

            // Load Unicode font (Arial)
            String fontPath = getServletContext().getRealPath("/WEB-INF/fonts/arial.ttf");
            PdfFont font = PdfFontFactory.createFont(fontPath, PdfEncodings.IDENTITY_H, true);

            doc.setFont(font);

            doc.add(new Paragraph("HÓA ĐƠN ĐẶT HÀNG")
                    .setFont(font)
                    .setBold()
                    .setFontSize(18)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(20));

            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");

            addField(doc, font, "Mã đơn hàng", orderId);
            addField(doc, font, "Ngày đặt hàng", order.getDate("orderDate") != null ? sdf.format(order.getDate("orderDate")) : "");
            addField(doc, font, "Khách hàng", order.getString("customerName"));
            addField(doc, font, "Số điện thoại", order.getString("phone"));
            addField(doc, font, "Email", order.getString("email"));
            addField(doc, font, "Địa chỉ", order.getString("address"));
            addField(doc, font, "Phương thức thanh toán", order.getString("paymentMethod"));
            addField(doc, font, "Trạng thái", order.getString("status"));

            doc.add(new Paragraph("\n").setFont(font));

            Table table = new Table(UnitValue.createPercentArray(new float[]{50, 20, 30}))
                    .useAllAvailableWidth();

            table.addHeaderCell(new Cell().add(new Paragraph("Sản phẩm").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Số lượng").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Tổng tiền (VND)").setFont(font).setBold()));

            table.addCell(new Cell().add(new Paragraph(order.getString("productNames")).setFont(font)));
            table.addCell(new Cell().add(new Paragraph(String.valueOf(order.getInteger("quantity"))).setFont(font)));
            table.addCell(new Cell().add(new Paragraph(String.format("%,.0f", order.getDouble("totalAmount"))).setFont(font)));

            doc.add(table);

            String note = order.getString("note");
            if (note != null && !note.isEmpty()) {
                doc.add(new Paragraph("\nGhi chú:").setBold().setFont(font));
                doc.add(new Paragraph(note).setFont(font));
            }

            doc.add(new Paragraph("\n\nNgười lập hóa đơn: ______________________")
                    .setTextAlignment(TextAlignment.RIGHT)
                    .setFont(font));

            doc.close();
        }
    }

    private void addField(Document doc, PdfFont font, String label, String value) {
        Paragraph p = new Paragraph()
                .add(new Text(label + ": ").setBold().setFont(font))
                .add(new Text(value != null ? value : "").setFont(font));
        doc.add(p);
    }

    @Override
    public void destroy() {
        if (mongoClient != null) mongoClient.close();
    }
}
