// web/email_service.js
function sendEmail(serviceId, templateId, userId, templateParams) {
    return emailjs.send(serviceId, templateId, templateParams, userId);
}
