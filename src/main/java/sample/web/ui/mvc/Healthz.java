package sample.web.ui.mvc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;


@Component
public class Healthz implements HealthIndicator {

    private static final Logger logger = LoggerFactory.getLogger(Healthz.class);

    @Value("#{systemEnvironment['HOSTNAME']}")
    private String hostname;

    @Override
    public Health health() {
        int errorCode = check();
        if (errorCode != 0) {
            logger.warn("health check error");
            return Health.down().withDetail("Error Code",errorCode).build();
        }
        //추가 적으로 체킹해야될 부분 삽입
        return Health.up().withDetail("HOSTNAME",hostname).build();
    }

    public int check() {
        logger.warn("health check");
        // 어플리케이션 체크 로직
        return 0;
    }
}