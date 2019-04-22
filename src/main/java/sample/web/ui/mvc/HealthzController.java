package sample.web.ui.mvc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.health.Health;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthzController {
    @Autowired
    private Healthz healthz;

    @RequestMapping("/health")
    public Health healthInfo() {
        return healthz.health();
    }
}
