package com.jsp.jsp_demo.config.web;

import com.opensymphony.sitemesh.webapp.SiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

@Configuration
@Component
public class SiteMeshConfig {
    @Bean
    public FilterRegistrationBean siteMeshFilter() {
        FilterRegistrationBean filter = new FilterRegistrationBean();
        filter.setFilter(new SiteMeshFilter());
        return filter;
    }
}