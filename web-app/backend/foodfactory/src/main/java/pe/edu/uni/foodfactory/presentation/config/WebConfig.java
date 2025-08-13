package pe.edu.uni.foodfactory.presentation.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                //.allowedOrigins("http://localhost:4200","http://192.168.100.55:4200")
                .allowedOrigins("*")
                .allowedMethods("*");
    }
}