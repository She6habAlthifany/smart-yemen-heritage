import AdminJS, { ComponentLoader } from 'adminjs'
import * as AdminJSExpress from '@adminjs/express'
import * as AdminJSMongoose from '@adminjs/mongoose'
import dotenv from 'dotenv'
import { fileURLToPath } from 'url'
import path from 'path'
import { createRequire } from 'module'

dotenv.config()

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const require = createRequire(import.meta.url)
const mongooseBackend = require('../backend/node_modules/mongoose')

const componentLoader = new ComponentLoader()

// 🚨 مهم جداً: استخدم .js وليس .jsx
const componentPath = path.join(__dirname, './components/Dashboard.js').replace(/\\/g, '/')

// إضافة الكمبوننت
const Components = {
  Dashboard: componentLoader.add('Dashboard', componentPath),
}

AdminJSMongoose.Resource.validate = AdminJSMongoose.validate
AdminJS.registerAdapter(AdminJSMongoose.default || AdminJSMongoose)

const MONGO_URI = "mongodb+srv://shehapsalem9_db_user:gsxC6k6OMdr7X5Za@cluster0.7jpeu2l.mongodb.net/?appName=Cluster0";

const connectDB = async () => {
  try {
    await mongooseBackend.connect(MONGO_URI)
    console.log("✅ Connected to MongoDB Successfully")
  } catch (err) {
    console.error("❌ MongoDB Connection Error:", err)
  }
}
connectDB()

// استيراد الموديلات
import User from '../backend/models/User.js'
import Content from '../backend/models/Content.js'
import ContentDetails from '../backend/models/ContentDetails.js'
import ContentType from '../backend/models/ContentType.js'
import Service from '../backend/models/Service.js'
import Banner from '../backend/models/Banner.js'
import ARView from '../backend/models/ARView.js'
import Feedback from '../backend/models/Feedback.js'
import Notification from '../backend/models/Notification.js'
import Admin from '../backend/models/Admin.js'

const adminOptions = {
  rootPath: '/admin',
  componentLoader,
  resources: [
    { resource: User, options: { navigation: { name: 'الإدارة', icon: 'User' } } },
    { resource: Admin, options: { navigation: { name: 'الإدارة', icon: 'Key' } } },
    { resource: Content, options: { navigation: { name: 'المحتوى', icon: 'FileText' } } },
    { resource: ContentDetails, options: { navigation: { name: 'المحتوى' } } },
    { resource: ContentType, options: { navigation: { name: 'المحتوى' } } },
    { resource: Service, options: { navigation: { name: 'المحتوى' } } },
    { resource: ARView, options: { navigation: { name: 'المحتوى', icon: 'Camera' } } },
    { resource: Banner, options: { navigation: { name: 'التسويق', icon: 'Megaphone' } } },
    { resource: Feedback, options: { navigation: { name: 'التسويق', icon: 'Star' } } },
    { resource: Notification, options: { navigation: { name: 'التسويق' } } },
  ],
  branding: {
    companyName: 'تراث اليمن الذكي',
    logo: false,
  },
  dashboard: {
    component: Components.Dashboard,
    handler: async () => {
      const usersCount = await User.countDocuments()
      const contentCount = await Content.countDocuments()
      const feedbackCount = await Feedback.countDocuments()
      return { usersCount, contentCount, feedbackCount }
    }
  }
}

const adminJs = new AdminJS(adminOptions)

const ADMIN_EMAIL = "admin@admin.com"
const ADMIN_PASSWORD = "123456"

const router = AdminJSExpress.buildAuthenticatedRouter(
  adminJs,
  {
    authenticate: async (email, password) => {
      if (email === ADMIN_EMAIL && password === ADMIN_PASSWORD) {
        return { email: ADMIN_EMAIL, role: 'admin' }
      }
      return null
    },
    cookieName: 'adminjs',
    cookiePassword: 'some-super-secret-password-that-is-long-enough-and-secure',
  },
  null,
  {
    resave: false,
    saveUninitialized: true,
    secret: 'session-secret-key',
  }
)

export { adminJs, router }
