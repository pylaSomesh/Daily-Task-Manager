package com.taskmanager.servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import com.taskmanager.dao.UserDAO;
import com.taskmanager.model.User;
import com.taskmanager.util.ImageUtil;
import com.taskmanager.util.ToastUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/uploadProfilePicture")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 2 * 1024 * 1024,
        maxRequestSize = 3 * 1024 * 1024)
public class UploadProfilePictureServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        int userId = sessionUser.getId();

        Part filePart = request.getPart("profileImage");

        if (filePart == null || filePart.getSize() == 0) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Please select an image to upload.");
            return;
        }

        String submittedFileName = getSubmittedFileName(filePart);

        if (!ImageUtil.isValidImage(filePart, submittedFileName)) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error",
                    "Invalid image. Allowed: JPG, PNG, GIF, WEBP. Max size: 2MB.");
            return;
        }

        String extension = ImageUtil.resolveExtension(
                submittedFileName, filePart.getContentType());
        String fileName = "user_" + userId + "_" + System.currentTimeMillis() + extension;
        String relativePath = "uploads/profiles/" + fileName;

        String uploadDir = getServletContext().getRealPath("/uploads/profiles");
        File directory = new File(uploadDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        File destination = new File(directory, fileName);

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, destination.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        User existing = userDAO.getUserById(userId);
        if (existing != null && existing.getProfileImage() != null
                && !existing.getProfileImage().trim().isEmpty()) {
            deleteOldImage(getServletContext().getRealPath("/"), existing.getProfileImage());
        }

        if (!userDAO.updateProfileImage(userId, relativePath)) {
            destination.delete();
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Failed to save profile picture.");
            return;
        }

        User refreshedUser = userDAO.getUserById(userId);
        if (refreshedUser != null) {
            refreshedUser.setPassword(null);
            session.setAttribute("user", refreshedUser);
        }

        ToastUtil.flashRedirect(response, session,
                "profile", "success", "Profile picture updated successfully.");
    }

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) {
            return "";
        }
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim()
                        .replace("\"", "");
            }
        }
        return "";
    }

    private void deleteOldImage(String contextPath, String relativePath) {
        if (relativePath == null || relativePath.contains("..")) {
            return;
        }
        File oldFile = new File(contextPath, relativePath.replace("/", File.separator));
        if (oldFile.exists() && oldFile.isFile()) {
            oldFile.delete();
        }
    }
}
