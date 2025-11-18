const { mongoose } = require("../../config/mongodb");

// Schema flexible para reportes que pueden tener estructuras muy variadas
const reporteSchema = new mongoose.Schema(
    {
        tipo: {
            type: String,
            required: true
        },
        titulo: {
            type: String,
            required: true
        },
        fechaCreacion: {
            type: Date,
            default: Date.now
        },
        creadoPor: {
            type: String,
            required: true
        },
        // Campo flexible que permite cualquier estructura
        datos: {
            type: mongoose.Schema.Types.Mixed,
            required: true
        },
        // Metadatos adicionales opcionales
        metadata: {
            type: mongoose.Schema.Types.Mixed,
            default: {}
        }
    },
    {
        collection: "reportes",
        timestamps: true // Agrega createdAt y updatedAt automáticamente
    }
);

// Índices para mejorar las búsquedas
reporteSchema.index({ tipo: 1 });
reporteSchema.index({ fechaCreacion: -1 });
reporteSchema.index({ creadoPor: 1 });

const Reporte = mongoose.model("Reporte", reporteSchema);

module.exports = Reporte;

