package com.flowershop.controller;

import com.flowershop.model.Flower;
import com.flowershop.repository.FlowerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class FlowerController {

    private static final Logger logger = LoggerFactory.getLogger(FlowerController.class); // Khai báo và khởi tạo logger

    @Autowired
    private FlowerRepository flowerRepository;

    @GetMapping("/dashboard")
    public String getDashboard(Model model) {
        List<Flower> flowers = flowerRepository.findAll();
        model.addAttribute("flowers", flowers);
        return "dashboard";
    }

    @PostMapping("/addFlower")
    public String addFlower(
            @RequestParam("id") String id,
            @RequestParam("name") String name,
            @RequestParam("price") double price,
            @RequestParam("image") MultipartFile image,
            @RequestParam("category") String category,
            @RequestParam("stock") int stock,
            @RequestParam("description") String description,
            RedirectAttributes redirectAttributes) throws IOException {

        try {
            if (image.isEmpty()) {
                redirectAttributes.addFlashAttribute("success", false);
                redirectAttributes.addFlashAttribute("message", "Vui lòng chọn ảnh!");
                return "redirect:/dashboard";
            }

            String uploadDir = "src/main/resources/static/images/";
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.write(filePath, image.getBytes());

            Flower flower = new Flower();
            flower.setId(id);
            flower.setName(name);
            flower.setPrice(price);
            flower.setImage("/images/" + fileName);
            flower.setCategory(category);
            flower.setStock(stock);
            flower.setDescription(description);

            flowerRepository.save(flower);
            logger.info("Thêm sản phẩm thành công: {}", flower);

            redirectAttributes.addFlashAttribute("success", true);
            redirectAttributes.addFlashAttribute("message", "Sản phẩm đã được thêm thành công!");
        } catch (IOException e) {
            logger.error("Lỗi khi lưu ảnh: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("success", false);
            redirectAttributes.addFlashAttribute("message", "Lỗi khi lưu ảnh: " + e.getMessage());
        } catch (Exception e) {
            logger.error("Lỗi khi thêm sản phẩm: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("success", false);
            redirectAttributes.addFlashAttribute("message", "Đã xảy ra lỗi khi thêm sản phẩm: " + e.getMessage());
        }
        return "redirect:/dashboard";
    }
}