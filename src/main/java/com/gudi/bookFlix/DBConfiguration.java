/**
 * 데이터베이스 연결 및 MyBatis 설정을 위한 구성 클래스
 * HikariCP를 사용한 데이터 소스 설정과 MyBatis SqlSessionFactory 및 SqlSessionTemplate을 구성
 * application.properties 파일의 설정을 읽어 데이터베이스 연결 관리
 *
 * 작성자: 김두호
 * 작성일: 2023-07-21
 */
package com.gudi.bookFlix;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
@PropertySource("classpath:/application.properties")
public class DBConfiguration {
    private static final Logger logger = LogManager.getLogger(DBConfiguration.class);

	/**
	 * HikariCP 설정을 불러옴
	 * @return HikariConfig 객체
	 */
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource.hikari") 
    public HikariConfig hikariConfig(){
        return new HikariConfig();
    }

	/**
	 * HikariCP를 사용한 데이터 소스를 생성
	 * @return DataSource 객체
	 */
	@Bean
	public DataSource dataSource() {
		DataSource dataSource = new HikariDataSource(hikariConfig());
		logger.info("datasource : {}", dataSource);
		return dataSource;
	}

	@Autowired
	private ApplicationContext applicationContext = null;// 게으른 컨테이너- 꼭 필요할 때 - 적재적소에

	/**
	 * MyBatis의 SqlSessionFactory를 생성
	 * @param dataSource 데이터 소스 객체
	 * @return SqlSessionFactory 객체
	 * @throws Exception 예외 처리
	 */
	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(dataSource);
		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:/mapper/**/*.xml"));
		return sqlSessionFactoryBean.getObject();
	}

	/**
	 * MyBatis의 SqlSessionTemplate을 생성
	 * @param sqlSessionFactory SqlSessionFactory 객체
	 * @return SqlSessionTemplate 객체
	 */
    @Bean
	public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
		return new SqlSessionTemplate(sqlSessionFactory);
	}
}
