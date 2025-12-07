// ====== ملف: assistantService.js (باستخدام SDK) ======

// تأكد أنك استدعيت require('dotenv').config() في ملف server.js أو index.js

const { GoogleGenAI } = require("@google/genai");

// لن تحتاج لمكتبة axios هنا
// const axios = require("axios"); 

module.exports = {
  ask: async function (message) {
    try {
      const apiKey = process.env.GEMINI_API_KEY;

      if (!apiKey) {
        // يمكنك إرجاع خطأ 500 إذا لم يتم تحميل المفتاح
        throw new Error("GEMINI_API_KEY is not loaded."); 
      }
      
      console.log("Sending message to Gemini (via SDK):", message);

      // تهيئة عميل GoogleGenAI
      const ai = new GoogleGenAI(apiKey); 

      // استخدام الدالة generateContent التي تقبل systemInstruction و config
      const response = await ai.models.generateContent({
          model: "gemini-2.5-flash",
          contents: [
              // نرسل فقط رسالة المستخدم هنا، ونحدد دور النظام خارجها
              { role: "user", parts: [{ text: message }] }
          ],
          config: {
              // هذا مقبول هنا
              systemInstruction: "You are a Yemen history assistant.", 
              temperature: 0.7,
          }
      });
      
      // استرجاع النص مباشرة من الرد
      return response.text; 

    } catch (error) {
      // قم بطباعة الخطأ الحقيقي للمساعدة في التصحيح
      console.error("Assistant service (SDK) error:", error);
      // ارفع الخطأ العام الذي يظهر في Postman
      throw new Error("Assistant Error");
    }
  }
};
// =======================================================