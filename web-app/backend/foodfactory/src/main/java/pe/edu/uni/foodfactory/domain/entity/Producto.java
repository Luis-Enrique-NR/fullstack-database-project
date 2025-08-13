package pe.edu.uni.foodfactory.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "productos")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id_producto")
    private Long id;

    @Column(length = 10, unique = true, nullable = false)
    private String codigo;

    @Column(length = 70, nullable = false)
    private String nombre;

    @Column(name = "peso_producto", precision = 5, scale = 2)
    private BigDecimal peso;

    @Column(name = "cantidad_envases_empaque")
    private Short cantidadEnvasesEmpaque;

    @Column(length = 18)
    private String presentacion;

    @Column(name = "precio_unitario", precision = 5, scale = 2)
    private BigDecimal precioUnitario;

    private String descripcion;
}
