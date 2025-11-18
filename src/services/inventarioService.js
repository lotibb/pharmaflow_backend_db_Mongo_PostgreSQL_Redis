const sequelize = require("../config/sql");
const Lote = require("../models/sql/Lote");
const Venta = require("../models/sql/Venta");

async function venderLote(loteId, cantidad) {
    return sequelize.transaction(async (t) => {


        const lote = await Lote.findByPk(loteId, { transaction: t });
        if (!lote) throw new Error("Not finding Lote.");


        if (lote.cantidad < cantidad) {
            throw new Error("Not enough stock.");
        }

        const versionInitiale = lote.version;


        const [updated] = await Lote.update(
            {
                cantidad: lote.cantidad - cantidad,
                version: versionInitiale + 1
            },
            {
                where: { id: loteId, version: versionInitiale },
                transaction: t
            }
        );

        if (updated === 0) {
            throw new Error("Conflicto concurrential : try again.");
        }


        await Venta.create(
            {
                medicamentoId: lote.medicamentoId,
                loteId: lote.id,
                cantidadVendida: cantidad
            },
            { transaction: t }
        );


        return {
            success: true,
            newQty: lote.cantidad - cantidad
        };
    });
}

module.exports = { venderLote };
